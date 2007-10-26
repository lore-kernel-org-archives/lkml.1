Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbXJZSTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbXJZSTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXJZST3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:19:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64114 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbXJZST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:19:28 -0400
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <gregkh@suse.de>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200710261112.19716.jbarnes@virtuousgeek.org>
References: <200710181401.50470.jbarnes@virtuousgeek.org>
	 <200710260957.15137.jbarnes@virtuousgeek.org>
	 <3ae72650710261010p195e2228h91c9cb11829c2a77@mail.gmail.com>
	 <200710261112.19716.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 20:21:05 +0200
Message-Id: <1193422865.2190.18.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ohPzxteF/r46mBumQx+YZdT8851IxpVjoYKG
 /H+C3uovESSbVrJ5j5YJryTZqJZ5IhSwXpJOYXYNrtyE1rpI0C
 Z6KqZOxaRu7JAo74kjtKxJGzor3AbTu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 11:12 -0700, Jesse Barnes wrote:
> On Friday, October 26, 2007 10:10 am Kay Sievers wrote:
> > The conversion is already queued in Greg's tree, and in -mm:
> > http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f
> >=driver/drm-convert-from-class_device-to-device-in-drivers-char-drm.pa
> >tch;h=f993183d1cb017f981cc2232d17930af40459bd8;hb=HEAD
> 
> Hm, I've done it slightly differently, by adding an actual device to the 
> drm_device structure...  I'll post it once I've cleaned it up a little 
> more.

Sure, as long as "struct class_device" is no longer used in the code,
and you don't embed two "struct device" device structures in a single
object, all should be fine.
We plan to remove "struct class_device" soon from the kernel. :)

Thanks,
Kay

