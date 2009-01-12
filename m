Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZALWJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZALWJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbZALWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:08:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:25548 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbZALWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:08:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VwogRN38jxXwqFd+UBHOLpvlgWq/PDWOVUseSGJwjbauajXndOlRfxzPXxf0DbEu8S
         tv/haBGFoUDEVgA5OTwr3O6afutmvyO1XTDZuWJsLD/3L1IA32aUO0DJojrnUoTiQCh6
         9SxA8WAKfQnBjQI8zkyhmbxVXalv2Usif26+c=
Message-ID: <621d098f0901121408y2cf8c2c9y2a6a5cc77ea8e8f5@mail.gmail.com>
Date: Mon, 12 Jan 2009 23:08:03 +0100
From: "Jan Dittmer" <jdi@l4x.org>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Cc: "Dave Airlie" <airlied@gmail.com>, "Diego Calleja" <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org, eric.anholt@intel.com, airlied@linux.ie
In-Reply-To: <200901121353.40270.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	 <200901120956.31728.jbarnes@virtuousgeek.org>
	 <621d098f0901121319j1be02f82j368250314664b997@mail.gmail.com>
	 <200901121353.40270.jbarnes@virtuousgeek.org>
X-Google-Sender-Auth: 0fdc0fb297c92050
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 10:53 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> name of display: :0.0
>> libGL: XF86DRIGetClientDriverName: 1.9.0 i965 (screen 0)
>> libGL: OpenDriver: trying /usr/local/lib/dri/i965_dri.so
>> drmOpenDevice: node name is /dev/dri/card0
>> drmOpenDevice: open result is 4, (OK)
>> drmOpenByBusid: Searching for BusID pci:0000:00:02.0
>> drmOpenDevice: node name is /dev/dri/card0
>> drmOpenDevice: open result is 4, (OK)
>> drmOpenByBusid: drmOpenMinor returns 4
>> drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
>> libGL error: drmMap of framebuffer failed (Resource temporarily
>> unavailable) libGL error: reverting to software direct rendering
>>
>> ?
>> This is with latest mesa git libGL. Any special compilation options for
>> mesa?
>
> Nope, not afaik.  Are you sure UXA is enabled?  And that Mesa was built
> against the same libdrm bits as your 2D driver?  If so, then I guess it's
> time to file a bug. :)

With the patches againg 29-rc1 from here
http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=3a03ac1a0223f779a3de313523408ddb099e5679;hp=dc1336ff4fe08ae7cfe8301bfd7f0b2cfd31d20a
and here
http://groups.google.com/group/linux.kernel/msg/26aa0471cfb54b06?dmode=source&output=gplain
at least glxinfo works.

Anyways thanks for your help, time to get some sleep,

Jan
