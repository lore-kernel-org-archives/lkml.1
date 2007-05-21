Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbXEUI2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbXEUI2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbXEUI2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:28:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:8689 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbXEUI2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T0j2SHAgUdC3iqM7ZzpuQGhvtGTYT6BhmqKtzlzBFLAAd5a/mIwaiMUMJ0F0TXA0zP5X1t6xEt5pTQYnDRlO5AwGYfFSW0GGS1WhX+S/yOYzchOEX9OnEoHeCWmSq4bm2mr4oy/kDPbdKtlCywPcENuW2yBKV5Yb1q9+TpZkzog=
Message-ID: <21d7e9970705210127o2360cd63mb8a41fdab9f211f9@mail.gmail.com>
Date: Mon, 21 May 2007 18:27:54 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jon Smirl" <jonsmirl@verizon.net>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jesse.barnes@intel.com>, jonsmirl@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <pan.2007.05.20.17.41.22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <pan.2007.05.20.17.41.22@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jon Smirl <jonsmirl@verizon.net> wrote:
> On Thu, 17 May 2007 14:23:45 -0700, Jesse Barnes wrote:
>
> > In collaboration with the FB guys, we've been working on enhancing the
> > kernel's graphics subsystem in an attempt to bring some sanity to the
> > Linux graphics world and avoid the situation we have now where several
> > kernel and userspace drivers compete for control of graphics devices.
>
> How is supporting different users logged into each head going to work?
> The original model for this was to give each head its own fbdev device.
> It is important that each user be able to set their own mode without being
> root.

TThe problem with that is the concept of heads is flawed... there is
in reality no such
thing, you have crtcs and outputs, no heads. So any attempt to enforce
the head concept involves putting policy into the kernel, as if I have
3 outputs but 2 crtcs how do I decide the mappings without the admin
telling the kernel,

As for moving other card drivers they will move as people see fit to
move them there probably isn't much gain in moving single crtc/output
cards..

Dave.

>
> Jon Smirl
> jonsmirl@gmail.com
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
x.org/lkml/
>
x.org/lkml/
>
