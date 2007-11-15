Return-Path: <linux-kernel-owner+w=401wt.eu-S932483AbXKOUlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbXKOUlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXKOUk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:40:59 -0500
Received: from smtp108.plus.mail.mud.yahoo.com ([68.142.206.241]:22557 "HELO
	smtp108.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750959AbXKOUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:40:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Fgdp1ldkj0lROVenoYQYgJxbgXE4/AhZtZfNhzmBDv0aZ0iAr5hazsRM+wssR8OYjbpizGm15WiowPJTdpV4JS3blRfyJUjvS+omtjaj60KRCqqZbIwivr0iJalM6gl3uaFdxPH2SoDmIUMkyIs+EyMqCMkMc7KVaY5w+WBXqBA=  ;
X-YMail-OSG: wxk16NsVM1lS0DgiSSkHFy_5JbUKMvsBE1EJtQcHkd0tOWHozFxXeDP7q5cAHih1n_vWnJlqVA--
Date: Thu, 15 Nov 2007 21:40:47 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Lucy McCoy <lucy@keyspan.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] keyspan: init termios properly
Message-ID: <20071115204047.GA5766@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20071103100301.GA5615@gollum.tnic> <473C86A2.1060505@keyspan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <473C86A2.1060505@keyspan.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 09:49:22AM -0800, Lucy McCoy wrote:
> Greg & Boris,
>
> I've been out of town and just saw this.
>
> This patch will work with the 19HS but WILL BREAK all other Keyspan
> adapters.  It will take me a few days to get to looking at a correct fix but
> that keyspan_send_setup(port, 1) (and the '1' is the important part) must 
> happen once
> when the port is first opened.  The cflag can just be set to whatever the 
> normal default
> is for your serial environment.  What are the defaults?

Hi Lucy,

sorry but i don't have the other usb-to-serial models to test them too, i guess
you're in the position to do that :) Well, from what i've unterstood from
reading the code, you can still do the keyspan_send_setup() call since the
switch-case-statement is not handling the 19s series so while this call won't have any
influence on them, it'll still init the others properly, no? Anyway, you can send me your
fix for testing.

Thanks.

-- 
Regards/Gruﬂ,
    Boris.
