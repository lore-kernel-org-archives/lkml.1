Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYGXPUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYGXPUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYGXPTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:19:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:4072 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYGXPTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:19:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pQ+YCMncP6FESKYo0uBy+cjcYHPULUQjhAJQqRBkz168uRoEUYzCpMKq9ylcEa0wef
         VSnF4uoZC/tzZVOWB+y/LI4tPFRg/PctFUlbiE97infoYTlr8UAU3I+nCZRav5Y18qt9
         blit+gbLaqe1+6uWG4Ty80QQkdbFMB5KfhkW8=
Message-ID: <38b2ab8a0807240819s48a233a0xb73e0da4c732020e@mail.gmail.com>
Date: Thu, 24 Jul 2008 17:19:52 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: Re: KGDB fails to pass selft tests on x86-64 (v2.6.26)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <488891F2.9020509@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0807240624v7ec90c50n8105f830d10dddd@mail.gmail.com>
	 <38b2ab8a0807240708j7d6782b7te6123fdd7416ec95@mail.gmail.com>
	 <488891F2.9020509@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 24, 2008 at 4:30 PM, Jason Wessel
<jason.wessel@windriver.com> wrote:
>
> It is because the qemu you are using does not support hardware
> breakpoints.  The tests will warn, but the kernel will continue to boot
> and tell you that hw breakpoint support doesn't work on your simulated
> hardware.

ah ok, thanks.

While I have your attention, I sometimes (well pretty often actually) got this
inside my gdb session:

   (gdb) n
   warning: Invalid remote reply: 00

or

   (gdb) n
   warning: Invalid remote reply: 00
   warning: Invalid remote reply:
c0dcb40f0081ffff08e59f0f0081ffff00b1a40f0081ffff8086400f0081ffff704e2c81ffffffff01000000008000000d00000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000ffffffffffffffff0000000000000000

Do you any idea what's wrong in this case ?

>
> Also, if you plan to use software breakpoints, please make sure to turn
> off CONFIG_DEBUG_RODATA, else they will not work.   This is a regression
> which will is on my list of things to take a look at, as time permits.
>

Yes I did that since I did notice a previous post where you adviced the same
thing.

Thanks
-- 
Francis
