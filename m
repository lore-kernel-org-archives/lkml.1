Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbXJZSO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbXJZSO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbXJZSOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:14:18 -0400
Received: from outbound-mail-44.bluehost.com ([69.89.18.13]:60238 "HELO
	outbound-mail-44.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752346AbXJZSOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:14:17 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Date: Fri, 26 Oct 2007 11:12:18 -0700
User-Agent: KMail/1.9.7
Cc: "Greg KH" <gregkh@suse.de>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>
References: <200710181401.50470.jbarnes@virtuousgeek.org> <200710260957.15137.jbarnes@virtuousgeek.org> <3ae72650710261010p195e2228h91c9cb11829c2a77@mail.gmail.com>
In-Reply-To: <3ae72650710261010p195e2228h91c9cb11829c2a77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261112.19716.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2007 10:10 am Kay Sievers wrote:
> The conversion is already queued in Greg's tree, and in -mm:
> http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f
>=driver/drm-convert-from-class_device-to-device-in-drivers-char-drm.pa
>tch;h=f993183d1cb017f981cc2232d17930af40459bd8;hb=HEAD

Hm, I've done it slightly differently, by adding an actual device to the 
drm_device structure...  I'll post it once I've cleaned it up a little 
more.

> /sys/class/drm will look the same as with the class_device's, only if
> !CONFIG_SYSFS_DEPRECATED, there will be symlinks instead of
> directories, otherwise the same pathes, like for all other
> (converted) classes too.

Ok, thanks.

Jesse
