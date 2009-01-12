Return-Path: <linux-kernel-owner+w=401wt.eu-S1761858AbZALWnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761858AbZALWnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbZALWaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:30:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:21952 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640AbZALW37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:29:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Nfyf+QNgv0vxWKk58Ci2RIIajpLGvdWM7hEASMB6sREKe14T4sMaEKxEKVdF0U7DE1
         ZMwRVtIizvLz7576icPzGNvtPIJCRM6Mmw4MWGLDC/WurPj3+jd8CPvgD7hIGbzn5yOv
         RwxtKbIKxIf7Hhtok94XVo+xR6DMOCn4K+cfk=
Message-ID: <621d098f0901121429w6d0792e4g259c8bdbeebc8bdd@mail.gmail.com>
Date: Mon, 12 Jan 2009 23:29:57 +0100
From: "Jan Dittmer" <jdi@l4x.org>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Cc: "Dave Airlie" <airlied@gmail.com>, "Diego Calleja" <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org, eric.anholt@intel.com, airlied@linux.ie
In-Reply-To: <621d098f0901121408y2cf8c2c9y2a6a5cc77ea8e8f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	 <200901120956.31728.jbarnes@virtuousgeek.org>
	 <621d098f0901121319j1be02f82j368250314664b997@mail.gmail.com>
	 <200901121353.40270.jbarnes@virtuousgeek.org>
	 <621d098f0901121408y2cf8c2c9y2a6a5cc77ea8e8f5@mail.gmail.com>
X-Google-Sender-Auth: a5b6369a74a5cc7c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:08 PM, Jan Dittmer <jdi@l4x.org> wrote:
> On Mon, Jan 12, 2009 at 10:53 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>> name of display: :0.0
>>> libGL: XF86DRIGetClientDriverName: 1.9.0 i965 (screen 0)
>>> libGL: OpenDriver: trying /usr/local/lib/dri/i965_dri.so
>>> drmOpenDevice: node name is /dev/dri/card0
>>> drmOpenDevice: open result is 4, (OK)
>>> drmOpenByBusid: Searching for BusID pci:0000:00:02.0
>>> drmOpenDevice: node name is /dev/dri/card0
>>> drmOpenDevice: open result is 4, (OK)
>>> drmOpenByBusid: drmOpenMinor returns 4
>>> drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
>>> libGL error: drmMap of framebuffer failed (Resource temporarily
>>> unavailable) libGL error: reverting to software direct rendering
>>>
>>> ?
>>> This is with latest mesa git libGL. Any special compilation options for
>>> mesa?
>>
>> Nope, not afaik.  Are you sure UXA is enabled?  And that Mesa was built
>> against the same libdrm bits as your 2D driver?  If so, then I guess it's
>> time to file a bug. :)
>
> With the patches againg 29-rc1 from here
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=3a03ac1a0223f779a3de313523408ddb099e5679;hp=dc1336ff4fe08ae7cfe8301bfd7f0b2cfd31d20a
> and here
> http://groups.google.com/group/linux.kernel/msg/26aa0471cfb54b06?dmode=source&output=gplain
> at least glxinfo works.

Using drm-intel-next from anholt on top, I've working GL (yeah!) but
get millions of
[  649.472172] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
counter, -22
[  649.512429] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
counter, -22
[  649.554513] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
counter, -22
[  649.596972] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
counter, -22
[  649.638744] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
counter, -22

entries in my log. libGL says

do_wait: drmWaitVBlank returned -1, IRQs don't seem to be working correctly.
Try adjusting the vblank_mode configuration parameter.

?

Jan
