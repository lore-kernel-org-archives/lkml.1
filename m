Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYJHXO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYJHXO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 19:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYJHXOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 19:14:17 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:20303 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751977AbYJHXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 19:14:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Rv4ElnKxX98vORau7+dj0P8P7J/4h8dqSSBR3gLLcPIbrKXHd70Rj/WK/wLWTghmcYFUtJTK+hheJfaNKA9VnGT3g3L8P4imfagqqTHalwkPb/0/nYZpDrTtMAcfQ9O+VQOLwHqH97j3Irc7ZRjLoIV4UzWOai6pOpbk9omJZ2w=  ;
X-YMail-OSG: fwNiLvUVM1lNTAPpA3eYuMdlOR6Qe.u0WYlk4Fux82rYdFlkUvGhi0bNe3ZugopzOKifUUoKTYy7.zqeryjE_odFN2v1gmw6D0EV2BrULSNus_5WVLa7DmyuDoqGLUvxx5sl8k.xY8P8TMl4rFfJV575EIAjxALdjEQYeLoV
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [patch 2.6.27-rc8-git] add drivers/mfd/twl4030-core.c
Date: Wed, 8 Oct 2008 16:14:14 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
References: <200810061047.50127.david-b@pacbell.net> <200810081051.00132.david-b@pacbell.net> <20081008224123.GD4766@localdomain>
In-Reply-To: <20081008224123.GD4766@localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081614.14792.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008, Samuel Ortiz wrote:
> > There's more substantial IRQ stuff on the way, but
> > it won't be ready before the 2.6.28 merges start.
>
> I can still take patches during the merge window, if
> you think they're really ready and necessary.

I think they're necessary, but they'll be more ready
a bit later in the merge window.

Other issues are still stabilizing; right now we're
chasing down some unrelated issues.

Like ... it turns out some power management support
in the I2C driver is causing trouble with this
driver (intermittent failures).  Workaround is to
turn off I2C power management; the real fix seems
to involve recognizing that OMAP2 != OMAP3.

The problem first surfaced when the $SUBJECT core
moved from drivers/i2c/chips to drivers/mfd, and
some timings changed.  Intermittent failure then
morphed intoGood fun! ;)

- Dave

