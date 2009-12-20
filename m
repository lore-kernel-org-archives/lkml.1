Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZLTUjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZLTUjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 15:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZLTUjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 15:39:51 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:49819 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbZLTUju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 15:39:50 -0500
Message-ID: <4B2E8B94.1080007@msgid.tls.msk.ru>
Date: Sun, 20 Dec 2009 23:39:48 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [stable] Regression in 2.6.32.2: radeon KMS hangs system
References: <200912201723.10385.johannes.hirte@fem.tu-ilmenau.de>
In-Reply-To: <200912201723.10385.johannes.hirte@fem.tu-ilmenau.de>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Hirte wrote:
> With 2.6.32.2 the system hangs completely with black screen when modprobing 
> radeon with modeset=1. I was able to connect via ssh, but after entering the 
> password nothing happend. I didn't got a prompt. Only SysRq worked. I've 
> tracked it down to the following patch:
> 
> From 500b758725314ab1b5316eb0caa5b0fa26740e6b Mon Sep 17 00:00:00 2001
> From: Alex Deucher <alexdeucher@gmail.com>
> Date: Wed, 2 Dec 2009 11:46:52 -0500
> Subject: drm/radeon/kms: handle vblanks properly with dpms on

Confirmed here on amd780g chipset.  I was about to debug/bisect the issue
right when the email arrived.  Reverting this patch makes my system bootable
again.

/mjt

> From: Alex Deucher <alexdeucher@gmail.com>
> 
> commit 500b758725314ab1b5316eb0caa5b0fa26740e6b upstream.
> 
> avivo chips
> 
> Copied from pre-avivo code.
> 
> Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
...
