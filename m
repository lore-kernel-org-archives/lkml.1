Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYIWI6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYIWI6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYIWI6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:58:03 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:59160 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYIWI6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:58:01 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 04:58:00 EDT
From: Ondrej Zary <linux@rainbow-software.org>
To: "=?iso-8859-1?q?S=F8ren?= Hauberg" <hauberg@gmail.com>
Subject: Re: [PATCH] usbtouchscreen, 2.6.25
Date: Tue, 23 Sep 2008 10:51:13 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.26-omega; KDE/4.1.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <ed7dcf450809230142l62bb00aapb92e6cb225f0cbba@mail.gmail.com>
In-Reply-To: <ed7dcf450809230142l62bb00aapb92e6cb225f0cbba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809231051.14016.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2008, Søren Hauberg wrote:
> Hi,
>   Currently, the 'usbtouchscreen' module sends raw data from the
> touchscreen directly to the user. However, in general, touchscreens
> need to be calibrated, and the raw data needs to be transformed
> according to the calibration, before the data can be used as an input
> device. Currently, some special purpose drivers exists for this in X,
> but the situation is a bit messy. I propose to add support for
> calibration parameters in the kernel. That way, we can also get usable
> touchscreens without X, without having to write special purpose
> drivers to handle the data from the touchscreen. The attached patch
> adds support for this. A module parameter (transform_xy)
> enables/disables this behavior, so the patch is not very intrusive,
> and should cause issues to current users.
>
> Comments would be appricated,

Calibration is a per-device thing. You can have more than one touchscreen (the 
swap_xy feature is also wrong, but better than nothing).

> Søren
>
> P.S. I'm not subscribed to the list so please keep me in the CC.

-- 
Ondrej Zary
