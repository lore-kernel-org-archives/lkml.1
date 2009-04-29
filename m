Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbZD2HBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbZD2HBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZD2HAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:00:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbZD2HAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:00:55 -0400
Date: Tue, 28 Apr 2009 23:57:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Peter Hanzel" <hanzelpeter@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       dri-devel@lists.sourceforge.net
Subject: Re: KMS + fb + FBIOPUT_VSCREENINFO
Message-Id: <20090428235723.f9495676.akpm@linux-foundation.org>
In-Reply-To: <8563BBE2A1F848B3B98C1A5FAE08BD09@avitech.sk>
References: <8563BBE2A1F848B3B98C1A5FAE08BD09@avitech.sk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc dri-devel)

On Tue, 28 Apr 2009 10:32:34 +0200 "Peter Hanzel" <hanzelpeter@gmail.com> wrote:

> Hello.
> 
> I have tried DRM with intel KMS and it is workiing. I am using only 
> framebuffer console.
> Fbcon initializes 1280x800 mode and it works like a charm.
> 
> But when I try to call FBIOPUT_VSCREENINFO on /dev/fb0, it always returns 
> EINVAL,
> I have checked drivers/gpu/drm/i915/intel_fb.c
> and found that
> 
> intelfb_check_var        returns -EINVAL     if (var->pixclock == -1 || 
> !var->pixclock)
> intelfb_set_par             returns -EINVAL    if (var->pixclock != -1) { 
> DRM_ERROR("PIXEL CLCOK SET\n");  return
> 
> So the FBIOPUT_VSCREENINFO always fails.
> 
> So is the change of resolution not supported through FBIOPUT_VSCREENINFO 
> call?
> 

