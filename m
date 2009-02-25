Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbZBYLck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbZBYLck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbZBYLcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:32:31 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56131 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbZBYLcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:32:31 -0500
Date: Wed, 25 Feb 2009 12:34:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@infradead.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [rfc] headers_check cleanups break the whole world
Message-ID: <20090225113423.GA22445@uranus.ravnborg.org>
References: <20090225032553.GD6690@bombadil.infradead.org> <20090225065632.GB21903@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225065632.GB21903@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> __KERNEL_STRICT_NAMES is a really old construct that has been 
> with us forever. It's not widely used ... i dont know how widely 
> it's being relied on. Sam, should we get rid of it, or should 
> user-space define __KERNEL_STRICT_NAMES in cases the glibc 
> definition collides with the kernel's definition?

hpa already answered this question and he knows
the userland<->kernel stuff better than I do.

IMO the best thing would be that Arnd rebased his original patch
and we get that rewieved and in the end applied.

	Sam
