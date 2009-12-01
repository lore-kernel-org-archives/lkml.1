Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZLAN2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZLAN2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZLAN2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:28:07 -0500
Received: from nox.protox.org ([88.191.38.29]:59679 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZLAN2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:28:07 -0500
Date: Tue, 1 Dec 2009 14:25:18 +0100
From: Jerome Glisse <glisse@freedesktop.org>
To: Christian Hartmann <cornogle@googlemail.com>
Cc: linux-kernel@vger.kernel.org, airlied@gmail.com, jglisse@redhat.com,
       dri-devel@lists.sf.net
Subject: Re: Problem KMS: TTM Failed moving buffer. Proposed placement
 0x00060004 / Out of aperture space or DRM memory quota && invalid
 framebuffer id
Message-ID: <20091201132518.GA2074@localhost.localdomain>
References: <ffd8902a0912010255k1bad9886l420b32df8c66551f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffd8902a0912010255k1bad9886l420b32df8c66551f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 11:55:03AM +0100, Christian Hartmann wrote:
> Todays test with KMS  w/o AGP (radeon.agopmode=-1)
> 
> 
> Starting Xorg I got instead of a normal X session a GDM login again,
> the last dmesg messages are:
> 
> 
> [  904.459254] wlan1: associated
> [ 1459.645513] [TTM] Failed moving buffer. Proposed placement 0x00060004
> [ 1459.645525] [TTM] Out of aperture space or DRM memory quota.
> [ 1459.645533] [drm:radeon_object_list_validate] *ERROR* radeon:
> failed to validate.
> [ 1459.645540] [drm:radeon_cs_ioctl] *ERROR* Failed to parse relocation !
> [ 1461.208487] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
> [ 1461.218685] [drm] LVDS-13: set mode 1024x768 1e

Full dmesg of when this happen will be helpfull.

Cheers,
Jerome
