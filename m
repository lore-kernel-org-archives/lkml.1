Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYHEJGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYHEJGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbYHEJGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:06:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:26847 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbYHEJGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v73xgwPcAkhmGNHnaLi1qBfyG9aTYKNYXi01nAv9PUTmQqU7sKQC0LHopTksY+tP8x
         fUJUthpXsqpBsrOlHdNUnVVufsuYjVNHue9+uqTsAU9CeLIlZ+zY9aRO5/x+wpSKucGL
         di9aK9vBzr9fhH+QdiLN13om6AyA/BO8801xE=
Date: Tue, 5 Aug 2008 10:05:02 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/14] uml: fix build when SLOB is enabled
Message-ID: <20080805090502.GA3039@hack.voiplan.pt>
References: <20080801224125.GA13727@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801224125.GA13727@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 06:41:25PM -0400, Jeff Dike wrote:
>From 94409ded7768e15b0d0a5a172d611073c72308de Mon Sep 17 00:00:00 2001
>
>Reintroduce uml_kmalloc for the benefit of UML libc code.  The
>previous tactic of declaring __kmalloc so it could be called directly
>from the libc side of the house turned out to be getting too intimate
>with slab, and it doesn't work with slob.
>
>So, the uml_kmalloc wrapper is back.  It calls kmalloc or whatever
>that translates into, and libc code calls it.
>
>kfree is left alone since that still works, leaving a somewhat
>inconsistent API.
>
>Signed-off-by: Jeff Dike <jdike@linux.intel.com>
>Cc: WANG Cong <xiyou.wangcong@gmail.com>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Looks good. Thanks. :)


-- 
The opposite of love is not hate, but indifference.
	--Elie Wiesel
