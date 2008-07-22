Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYGVTdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYGVTdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbYGVTdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:33:21 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:22727 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757137AbYGVTdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:33:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FgqfxuSw3QebNL93em0Vw3SBc3Qckou7IvTkvBRKEnMg1ejpg3/hJr8Tc0s0hTvcAg1b/kCF4LC+NqjTQSmT+kPDf4Jc0vwgcSHjAqsrbLKEH9UzRo2MBf+p3nRQYW51GzL1HQQESI2YZPZ27V5gKKFcW66BQCejNTwmoB/1PpQ=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: latest tree build failure -- cpm uart & gpio
Date: Tue, 22 Jul 2008 12:33:16 -0700
User-Agent: KMail/1.9.9
Cc: Kumar Gala <kumar.gala@freescale.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <FBE46DB6-A457-4AD8-9D6E-9D639AD04325@freescale.com> <20080722145330.GA2315@polina.dev.rtsoft.ru>
In-Reply-To: <20080722145330.GA2315@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221233.16723.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008, Anton Vorontsov wrote:
> On Tue, Jul 22, 2008 at 08:54:16AM -0500, Kumar Gala wrote:
> > can someone look at the following compile failure in linus's tree.  I'm 
> > guessing part of this has to do with Alan's tty changes (and might  
> > already be addressed?).
> >
> > include/asm-generic/gpio.h:131: error: implicit declaration of function 
> > 'gpio_get_value'
> > include/asm-generic/gpio.h:137: error: implicit declaration of function 
> > 'gpio_set_value'
> 
> I think this patch should help:
> 
> [OF] of_gpio: should use new <linux/gpio.h> header
> http://patchwork.ozlabs.org/linuxppc/patch?id=18750

Is that confirmed as fixing this, vs just being the Right Thing To Do?

 
> David, can you please Ack it? See Benjamin's mail:
> http://ozlabs.org/pipermail/linuxppc-dev/2008-July/060109.html

If you like ... but this is an OF-specific change, making
it conform with the interface spec, so I wouldn't expect
this to need more approvals than it's already got.

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> 
> -- 
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
> 


