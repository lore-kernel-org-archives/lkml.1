Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbXBWVSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbXBWVSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932968AbXBWVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:18:12 -0500
Received: from smtp102.sbc.mail.re2.yahoo.com ([68.142.229.103]:27313 "HELO
	smtp102.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752197AbXBWVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:18:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=jAtX+U0P/u6HhzzWJFRIsTs+Kr1DcM+NSfsKXTSVS/tGZONZX+KIQ4FMuoXhmlYRg99cHb+feMHL53PqO59KhvlnIQ4ICPvi4t7VOuoGASGuz5e4zuif+xZibW0t+Trng/IFSXoEonseQJWIDH/8BZjcmV+C3Xc0ILeHnw3Y+a0=  ;
X-YMail-OSG: NqyKDwoVM1n41zM88vyfJ1REEZ8HknEq5VGq19tiCQEFJ1P0yFJiSoPUTrkwphS4ie_v6oKbDk2c2icVbcWPp6HpyyDsdTPWYehRRIo8CFQTPzBCOhJBIPhrTeFJziORHqx1sF3QiOdio6Y-
Message-ID: <45DF5A24.507@sbcglobal.net>
Date: Fri, 23 Feb 2007 15:18:28 -0600
From: Matthew Frost <artusemrys@sbcglobal.net>
Reply-To: artusemrys@sbcglobal.net
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Mockern@yandex.ru
CC: linux-kernel@vger.kernel.org
Subject: Re: battery time living  in Linux
References: <45DF0417.000001.16244@webmail9.yandex.ru>
In-Reply-To: <45DF0417.000001.16244@webmail9.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern wrote:
> Hello,
> 
> I need to know how much time my battery will be alive (an embedded system).
> 
> How does Linux calculate it? How should I know that after 3 or 4 hours my battery will be completely discharged?
> 

Your battery will discharge at a rate proportionate to its total charge and the
wattage draw of the load (your embedded system, in this case) over time.  If the
drain is constant, as opposed to variable, this becomes easier to predict.
However, your system load probably won't be constant.  Also, the discharge rate
of a battery depends on the environment and age/condition of the battery.

I could just be missing something, but I am unaware of linux kernel
functionality for determining battery life.  There are benchmarks that can give
you an estimate, but they are artificial.  YMMV based on actual usage.  Check
out Len Brown et al. from the 2006 Ottawa Linux Symposium on Linux Laptop
Battery Life, and adapt to suit.  The only way to know for sure is to do the
tests yourself and get an idea of your average battery life.

Matt
