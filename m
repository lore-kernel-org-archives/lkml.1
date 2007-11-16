Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXKPGYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXKPGYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 01:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXKPGY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 01:24:27 -0500
Received: from smtp119.plus.mail.mud.yahoo.com ([209.191.106.150]:47978 "HELO
	smtp119.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750862AbXKPGY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 01:24:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=tEpVCCQUi92Kzvb5YB4tFr7BcO8lay/+8sM6B+4AW0RtEmS5Uj006DicQUdviCXODso13OiLzNaO/wU/5BXfhYkva8hK3Vt5PRDVE3EZRZIEPkF7ul0QO7E/gHzioREPmcAUb60P3wxBHHbyqJyAoH7l7xCAWR4Ar6ClbXU8HHU=  ;
X-YMail-OSG: _pNE3q4VM1mn.QuZBdKeewcLyUfhv8g.JioLwZQOoDy6iXDS89vwMYJqS8Tw_a8AH72v5svcf975iYz9i7G60YhaOe00GXBYPDRTzMie4TDhAedmwf4tBa_ghXrNug--
Date: Fri, 16 Nov 2007 07:24:13 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Lucy McCoy <lucy@keyspan.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] keyspan: init termios properly
Message-ID: <20071116062413.GA6765@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <46954.192.168.1.71.1195161016.webmail@192.168.1.71>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46954.192.168.1.71.1195161016.webmail@192.168.1.71>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:10:16PM -0800, Lucy McCoy wrote:

Hi Lucy,
> I'm not familiar with the termios stuff on Linux so can you take a look
> at the following modified code to see if this solves your NULL ptr problem?
will test the patch tomorrow and get back to you with results.
 
> Does cflag need to be set to anything other than CS8?  
i'm not that familiar with serial port settings either, but IIRC the cflag is
used to set the requested byte size of the transferred chars (cf
http://en.wikipedia.org/wiki/Serial_port#Data_Bits). Thus, according to the
above CS8 is used for setting up transfer of any kind of data over the serial connection.

> Is keyspan_open_port() always followed by a keyspan_set_termios()?
err, you mean keyspan_open() ...
..and yes, almost all of the usb to serial converter drivers call their own
*_set_termios-routine so that they could "synchronize" the line discipline user
settings with those of the converter.
-- 
Regards/Gruﬂ,
    Boris.
