Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZALVd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZALVd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZALVdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:33:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:12667 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZALVdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:33:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xnoEul9OvgeOcPpK1rI9a/DdwaGXqLng9iGtGHRJ7YKDauVicmgY14GZPLKZapWWNj
         9XRic9XsRhVyHZDvjbl+9TjrQP3i0EI4VmJ00Qw+OZRm9LBCRx266AfZO3GRv+wLQMGo
         bIcLTVrIuPh4C0CdI/fmXttXq2VS5HhnWcJn4=
Message-ID: <621d098f0901121333s4cfc6e6ey44dc7585dae5a7db@mail.gmail.com>
Date: Mon, 12 Jan 2009 22:33:44 +0100
From: "Jan Dittmer" <jdi@l4x.org>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Cc: "Dave Airlie" <airlied@gmail.com>, "Diego Calleja" <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org, eric.anholt@iintel.com, airlied@linux.ie
In-Reply-To: <621d098f0901121319j1be02f82j368250314664b997@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	 <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com>
	 <621d098f0901120037y4e17b4bn8d52a8ecdbc3fcff@mail.gmail.com>
	 <200901120956.31728.jbarnes@virtuousgeek.org>
	 <621d098f0901121319j1be02f82j368250314664b997@mail.gmail.com>
X-Google-Sender-Auth: cf99adff51590f5d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 10:19 PM, Jan Dittmer <jdi@l4x.org> wrote:
> On Mon, Jan 12, 2009 at 6:56 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Monday, January 12, 2009 12:37 am Jan Dittmer wrote:
>>> On Mon, Jan 12, 2009 at 9:04 AM, Dave Airlie <airlied@gmail.com> wrote:
>>> > the latest git should work with kms on most chipsets, we are still
>>> > chasing down some issues on some chipsets,
>>>
>>> So is there anything I can test to help you get it going on 'my' chipset
>>> (GM965, Lenovo X300)?
>>
>> I do much of my testing on GM965, so you should be able to get it to work with
>> the latest bits:
>>  - libdrm from git master of mesa/drm
>>  - mesa from git master of mesa/mesa
>>  - xf86-video-intel from git master
>>  - drm-intel-next from anholt's kernel tree
>>    (git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel)
>>
>> You'll need to use UXA as your AccelMethod.  If you run into issues with the
>> above, please file bugs (if you don't already see your issue filed) at
>> bugs.freedesktop.org.
>
> Thanks, at least X starts now, though dri is still broken. Is there
> any quick fix to:
>
> name of display: :0.0
> libGL: XF86DRIGetClientDriverName: 1.9.0 i965 (screen 0)
> libGL: OpenDriver: trying /usr/local/lib/dri/i965_dri.so
> drmOpenDevice: node name is /dev/dri/card0
> drmOpenDevice: open result is 4, (OK)
> drmOpenByBusid: Searching for BusID pci:0000:00:02.0
> drmOpenDevice: node name is /dev/dri/card0
> drmOpenDevice: open result is 4, (OK)
> drmOpenByBusid: drmOpenMinor returns 4
> drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
> libGL error: drmMap of framebuffer failed (Resource temporarily unavailable)
> libGL error: reverting to software direct rendering

For each call to glxinfo (or any other libgl program) I get

[   93.768928] glxinfo:3071 map pfn expected mapping type write-back
for e5720000-e5f90000, got uncached
[   93.769760] glxinfo:3071 freeing invalid memtype e5720000-e5f90000

written in my kernel log buffer.

Jan
