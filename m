Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYLKI64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYLKI64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYLKI6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:58:46 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57498 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753924AbYLKI6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:58:45 -0500
X-Greylist: delayed 1719 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 03:58:44 EST
Date: Thu, 11 Dec 2008 09:29:59 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Alex Raimondi <mailinglist@miromico.ch>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: Segfault in fbcmap.c => Compiler bug?
Message-ID: <20081211092959.6410c352@hcegtvedt>
In-Reply-To: <4940CE1F.5080605@miromico.ch>
References: <4940CE1F.5080605@miromico.ch>
Organization: Atmel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 09:23:59 +0100
Alex Raimondi <mailinglist@miromico.ch> wrote:

Hi Alex,

> I am using latest atmel avr32 kernel (2.6.27) form
> git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git.
> I am on it's master branch. I added a few patches specific to our own
> board (hammerhead). 
> 

Which toolchain are you using? If you have grabbed it from atmel.com
you have to download Buildroot for AVR32 [1] and build your own
toolchain. The toolchain on atmel.com is broken.

> When compiling with support for atmel_lcdfb the kernel segfaults at
> module probe.
> 
> This is the segfault output:
> 
> **********************************
> alg: No test for stdrng (krng)
> io scheduler noop registered
> io scheduler cfq registered (default)
> atmel_lcdfb atmel_lcdfb.0: 225KiB frame buffer at 13940000 (mapped at
> b3940000) Unable to handle kernel NULL pointer dereference at virtual

Does indeed look like a known GCC bug.

<snipp> rest of kernel dump and debugging>

1: www.atmel.no/buildroot

-- 
Best regards,
Hans-Christian Egtvedt
