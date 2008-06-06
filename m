Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYFFNol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYFFNol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYFFNoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:44:30 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:18531 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYFFNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gCQ9rhzROgXw05EjbReYRStZPbE5mM77vm8g+BRSm913lzD35QkoXYjzf5ZRPbKkhQ
         holYl+ItBnykBjTqkR2BWQpUIvM2k84bmzqHbSichHTzrb1upBcE3OBlLolMEo0I7A5c
         SswtROONkv4fOGxSeDkTjhPOaYvXt0ch3nzQs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.26-rc5] make HPET_RTC_IRQ track HPET_EMULATE_RTC
Date: Fri, 6 Jun 2008 16:44:23 +0300
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200806052241.44713.david-b@pacbell.net>
In-Reply-To: <200806052241.44713.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061644.23449.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 June 2008 08:41:44 David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> More Kconfig tweaks related to the legacy PC RTC code:
> 


Hi,

Remember long ago I had a discussion with you about HPET that
steals RTC irq in 'legacy replacement' mode, and rtc driver thus
implements rtc on 'top' of hpet.

New rtc-cmos driver doesn't do this emulation, thus it isn't compatible
with hpet driver.

But there is a solution,  I didn't agree with firstly, but then I did, and
I do agree now, and that to put hpet in normal mode.

What happened with patches that put hpet in normal independent mode?

Best regards,
	Maxim Levitsky
