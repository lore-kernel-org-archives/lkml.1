Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYLBKWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYLBKWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLBKWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:22:46 -0500
Received: from gate1.ipvision.dk ([217.195.186.3]:43836 "EHLO
	gate1.ipvision.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYLBKWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:22:45 -0500
X-Greylist: delayed 2684 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 05:22:45 EST
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: vanilla kernels hang randomly under Fedora 10 on system with Radeon card
References: <200812012342.32575.bzolnier@gmail.com>
From: Benny Amorsen <benny+usenet@amorsen.dk>
Date: Tue, 02 Dec 2008 10:37:45 +0100
In-Reply-To: <200812012342.32575.bzolnier@gmail.com> (Bartlomiej Zolnierkiewicz's message of "Mon\, 1 Dec 2008 23\:42\:32 +0100")
Message-ID: <m3y6yyzzme.fsf@ursa.amorsen.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -6.3 (------)
X-Spam-Report: ALL_TRUSTED=-3.3, AWL=0.049, BAYES_00=-3.099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

> Since the following error gets logged by kernel:
>
> [drm:drm_buffer_object_validate] *ERROR* Failed moving buffer. cef578c0 1444 4000027 10000a0
> [drm:drm_buffer_object_validate] *ERROR* Out of aperture space or DRM memory quota.
>
> and it also seems that system is more responsive now (it was kind of
> sluggish previously) my draft theory is that F9 -> F10 triggered some
> AGP memory management bug and CONFIG_DRM_RADEON_KMS happens to fix it
> but I'll leave figuring this up to the more knowledgeable people... ;)

I saw those error messages with kernel-2.6.27.5-117.fc10.i686 and
xorg-x11-drv-ati-6.9.0-54.fc10.i386 on a HP nx8220. It made
gnome-terminal basically useless, especially with tabs since it took
several seconds to switch tabs.

With the proprietary ATI driver everything works perfectly, including
suspend/resume (yay, successful suspend-to-RAM for the first time
since ACPI!)


/Benny

