Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab0BDTZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:25:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932078Ab0BDTZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:25:11 -0500
Date: Thu, 4 Feb 2010 11:24:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alex Deucher <alexdeucher@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
  out of staging."
In-Reply-To: <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002041123400.3707@localhost.localdomain>
References: <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>  <20100204071705.GA28403@elte.hu>  <20100204164859.GA17878@srcf.ucam.org>  <20100204170826.GA16397@elte.hu>  <20100204173602.GA19855@srcf.ucam.org>  <20100204175445.GB27361@elte.hu> 
 <20100204175928.GA20595@srcf.ucam.org> <20100204181218.GA6175@elte.hu>  <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>  <20100204190649.GB6665@elte.hu> <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Feb 2010, Alex Deucher wrote:
> 
> And if it crashes, he'll report a bug and we'll fix it.

Ok, you have a bug-report. See earlier in the thread:

> btw., i just found another bug activated via this same commit, a boot hang 
> after DRM init:
>
> [    9.858352] [drm] Connector 1:
> [    9.861417] [drm]   DVI-I
> [    9.864031] [drm]   HPD1
> [    9.866562] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
> [    9.872579] [drm]   Encoders:
> [    9.875540] [drm]     CRT2: INTERNAL_DAC2
> [    9.879541] [drm]     DFP1: INTERNAL_TMDS1
> [    9.883646] [drm] Connector 2:
> [    9.886695] [drm]   S-video
> [    9.889483] [drm]   Encoders:
> [    9.892463] [drm]     TV1: INTERNAL_DAC2
> [    9.896392] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
> [    9.901796] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
> [    9.909246] i2c i2c-0: NAK from device addr 0x50 msg #0
> [    9.914564] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
> [    9.919957] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
> [    9.927413] i2c i2c-1: NAK from device addr 0x50 msg #0

So can we get it fixed, please?

		Linus
