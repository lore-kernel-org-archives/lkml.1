Return-Path: <linux-kernel-owner+w=401wt.eu-S936986AbXGLAJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936986AbXGLAJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934765AbXGKX6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:58:23 -0400
Received: from gw.goop.org ([64.81.55.164]:45275 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936693AbXGKX6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:58:21 -0400
Message-ID: <46956E63.5090607@goop.org>
Date: Wed, 11 Jul 2007 16:57:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Roland McGrath <roland@frob.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
References: <20070711190434.D0F0C4D0555@magilla.localdomain>
In-Reply-To: <20070711190434.D0F0C4D0555@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> This patch adds the /sys/kernel/notes magic file.  Reading this delivers
> the contents of the kernel's .notes section.  This lets userland easily
> glean any detailed information about the running kernel's build that was
> stored there at compile time.
>   

Is .notes an allocated section?  I didn't think it necessarily appeared 
in any of the PT_LOAD segments, because the linux/elfnote.h macros don't 
necessarily set "a" on the section.

I have a patch to always do this, and also convert all the note 
generation to C code rather than asm.  If your patch works for you, 
however, it should be completely orthogonal.

    J
