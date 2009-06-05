Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZFEF7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZFEF7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZFEF7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:59:18 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:63170 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZFEF7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IRHmJWNhD62lN0MpKrf3uMe0QtdmNXDmGdK2nXSid1A8VXx7vtYexFgewU35IFMoqf
         UOMXDoyf0zxO/ObWtsU5DCvBHBn9oXJOAKKAuQuLS49otYVrYhIFa4ooRfiGt52FD7WV
         p3RjaXiKELYs3AwLiIWi15xLSuGTM5C6Ks1Ls=
MIME-Version: 1.0
In-Reply-To: <20090605054231.GA2212@gentoox2.trippelsdorf.de>
References: <alpine.DEB.2.00.0906040438210.7074@skynet.skynet.ie>
	 <20090605054231.GA2212@gentoox2.trippelsdorf.de>
Date: Fri, 5 Jun 2009 15:59:19 +1000
Message-ID: <21d7e9970906042259l56ba3382wa3413132fc2d8b10@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 3:42 PM, Markus
Trippelsdorf<markus@trippelsdorf.de> wrote:
> On Thu, Jun 04, 2009 at 04:39:50AM +0100, Dave Airlie wrote:
>>
>> Hi Linus,
>>
>> Please pull the 'drm-fixes' branch from
>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes


Okay Linus if you do pull this can you revert
6c51d1cfa0a370b48a157163340190cf5fd2346b

that works fine on my intel hw but seems to have a bad effect on radeon.

I'll get Ben to chase down where it goes wrong.

Dave.

>>
>> Have been out on holidays, so sorry these are a bit late, the radeon one
>> fixes a regression reported since -rc1 so is most important.
>>
>
> These »fixes« break DRI on my Radeon HD 3300 (RS780):
>
> drmOpenDevice: node name is /dev/dri/card0
> drmOpenDevice: open result is 10, (OK)
> drmOpenDevice: node name is /dev/dri/card0
> drmOpenDevice: open result is 10, (OK)
> drmOpenByBusid: Searching for BusID pci:0000:01:05.0
> drmOpenDevice: node name is /dev/dri/card0
> drmOpenDevice: open result is 10, (OK)
> drmOpenByBusid: drmOpenMinor returns 10
> drmOpenByBusid: drmGetBusid reports pci:0000:01:05.0
> (II) [drm] DRM interface version 1.3
> (II) [drm] Could not create SAREA for DRM lock.
> (EE) RADEON(0): [dri] DRIScreenInit failed.  Disabling DRI.
> (II) RADEON(0): RADEONRestoreMemMapRegisters() :
> (II) RADEON(0):   MC_FB_LOCATION   : 0x00c700c0 0x00c700c0
> (II) RADEON(0):   MC_AGP_LOCATION  : 0x003f0000
> (==) RADEON(0): Backing store disabled
> (WW) RADEON(0): Direct rendering disabled
> (EE) RADEON(0): Acceleration initialization failed
> (II) RADEON(0): Acceleration disabled
>
> Full Xorg.0.log is attached.
>
> --
> Markus
>
