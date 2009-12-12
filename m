Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbZLLLRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbZLLLRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 06:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761468AbZLLLRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 06:17:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37910 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761327AbZLLLRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 06:17:33 -0500
Date: Sat, 12 Dec 2009 12:17:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
Subject: Re: tree with htc dream support
Message-ID: <20091212111731.GA24713@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
 <1260054737.23633.35.camel@desktop>
 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-11 21:42:07, Arve Hj?nnev?g wrote:
> On Sat, Dec 5, 2009 at 4:38 PM, Brian Swetland <swetland@google.com> wrote:
> > Arve's about to take our common and msm trees and rebase them over the .32,
> > which may be useful for reference -- at least as a snapshot of a fully
> > functional set of patches that android donut and eclair run on, on
> > production hardware.  We'll make that available as soon as we have something
> > that's bootable.
> 
> A first pass of this is available in the android-msm-2.6.32-test1
> branch at git://android.git.kernel.org/kernel/experimental.git.

Thanks!

I get 

  CC      drivers/i2c/chips/mt9t013.o
drivers/i2c/chips/mt9t013.c: In function 'mt9t013_remove':
drivers/i2c/chips/mt9t013.c:1301: error: implicit declaration of
function 'i2c_detach_client'
make[3]: *** [drivers/i2c/chips/mt9t013.o] Error 1
make[2]: *** [drivers/i2c/chips] Error 2
make[1]: *** [drivers/i2c] Error 2

... I guess mt9t013 should depend on i2c? I'll try to fix the config.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
