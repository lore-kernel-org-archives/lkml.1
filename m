Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZALVxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZALVxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZALVxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:53:42 -0500
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:35928 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752247AbZALVxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:53:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hb4oMys0Ac9lB8yRRcj+DcYHcK2d8Nilr78HLwGMsdULIFRqkfFnedJ36kWaJny2Fs88iqpPGoceVvGsjy2cNmtu35ppqADoL9od20eDB3sP4Z4meUcU02bpECMaJrt+;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Date: Mon, 12 Jan 2009 13:53:39 -0800
User-Agent: KMail/1.9.10
Cc: "Dave Airlie" <airlied@gmail.com>, "Diego Calleja" <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org, eric.anholt@iintel.com, airlied@linux.ie
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com> <200901120956.31728.jbarnes@virtuousgeek.org> <621d098f0901121319j1be02f82j368250314664b997@mail.gmail.com>
In-Reply-To: <621d098f0901121319j1be02f82j368250314664b997@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121353.40270.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2009 1:19 pm Jan Dittmer wrote:
> On Mon, Jan 12, 2009 at 6:56 PM, Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:
> > On Monday, January 12, 2009 12:37 am Jan Dittmer wrote:
> >> On Mon, Jan 12, 2009 at 9:04 AM, Dave Airlie <airlied@gmail.com> wrote:
> >> > the latest git should work with kms on most chipsets, we are still
> >> > chasing down some issues on some chipsets,
> >>
> >> So is there anything I can test to help you get it going on 'my' chipset
> >> (GM965, Lenovo X300)?
> >
> > I do much of my testing on GM965, so you should be able to get it to work
> > with the latest bits:
> >  - libdrm from git master of mesa/drm
> >  - mesa from git master of mesa/mesa
> >  - xf86-video-intel from git master
> >  - drm-intel-next from anholt's kernel tree
> >    (git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel)
> >
> > You'll need to use UXA as your AccelMethod.  If you run into issues with
> > the above, please file bugs (if you don't already see your issue filed)
> > at bugs.freedesktop.org.
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
> libGL error: drmMap of framebuffer failed (Resource temporarily
> unavailable) libGL error: reverting to software direct rendering
>
> ?
> This is with latest mesa git libGL. Any special compilation options for
> mesa?

Nope, not afaik.  Are you sure UXA is enabled?  And that Mesa was built 
against the same libdrm bits as your 2D driver?  If so, then I guess it's 
time to file a bug. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
