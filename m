Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbZBYHEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbZBYHEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZBYHET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:04:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbZBYHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:04:18 -0500
Message-ID: <49A4EC8F.6090708@zytor.com>
Date: Tue, 24 Feb 2009 23:00:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Kyle McMartin <kyle@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] headers_check cleanups break the whole world
References: <20090225032553.GD6690@bombadil.infradead.org> <20090225065632.GB21903@elte.hu>
In-Reply-To: <20090225065632.GB21903@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Well, the intention is to clean up the situation somewhat.
> 
> __KERNEL_STRICT_NAMES is a really old construct that has been 
> with us forever. It's not widely used ... i dont know how widely 
> it's being relied on. Sam, should we get rid of it, or should 
> user-space define __KERNEL_STRICT_NAMES in cases the glibc 
> definition collides with the kernel's definition?
> 
> Note that if user-space is "playing utterly stupid games", it 
> can cause trouble no matter what scheme we pick - so we have to 
> filter out the reasonable problems that we should and can fix in 
> the kernel.
> 

__KERNEL_STRICT_NAMES is an anachronism that was put in to not break
libc5.  It has long outlived its usefulness, together with all the other
libc5 support crap in the kernel headers -- which do nothing but make
the kernel headers useless for any sane purposes.

Please let's just axe it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

