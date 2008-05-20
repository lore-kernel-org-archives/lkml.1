Return-Path: <linux-kernel-owner+w=401wt.eu-S933540AbYETQLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540AbYETQLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYETQLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:11:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:34291 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYETQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o2aoMuGxy18deQENQyTXc5HN3t8e6ldrq/MLcKiFHNLoXziiQRcdzlmka9wRD2wGCXPM5sC47URGLMoEl6sPwYLF7+Mxn1BPxAMFP7jxCvv39UiteXecwR72Q1LUoh/CsozKbwtYM2m7uuaif9V32iu8PAzpY2ZueyMTWEr2ZfE=
Message-ID: <b6a2187b0805200911x4cccd060v5644c87b51d7db9b@mail.gmail.com>
Date: Wed, 21 May 2008 00:11:10 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: recent 2.6.26 kernel hangs at suspend
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       "Shaohua Li" <shaohua.li@intel.com>, "Greg KH" <greg@kroah.com>,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <20080520074819.GA15659@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
	 <20080520074819.GA15659@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 3:48 PM, Pavel Machek <pavel@suse.cz> wrote:

>> If I don't enter X, it'll not hang on suspend to ram.
>
> Ok, so we have X in the mix.
>
> Can you try if it happens if you disable Intel framebuffer driver?

The whole problem went away after the latest git pull.

Looks like the commit below fixes the problem of failing on 2nd suspense.

I've tested whole day and it's suspending-resuming after many cycles.

Sorry, couldn't get to email whole day. Traveling. Slow train.

Thank you all for your help!!!
Jeff.


commit 860da5e578c25d1ab4528c0d1ad13f9969e3490f
Merge: 1bf9947... e948e99...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon May 19 13:30:40 2008 -0700

    Merge branch 'drm-patches' of git://git.kernel.org/pub/scm/linux/kernel/git/
airlied/drm-2.6

    * 'drm-patches' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm
-2.6:
      drm/i915: save and restore dsparb and d_state registers.
      drm/i915: fix off by one in VGA save/restore of AR & CR regs.
      drm: disable tasklets not IRQs when taking the drm lock spinlock
      Revert "drm/vbl rework: rework how the drm deals with vblank."
