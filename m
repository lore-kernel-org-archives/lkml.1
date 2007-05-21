Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbXEUP6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbXEUP6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbXEUP55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:57:57 -0400
Received: from outbound-mail-48.bluehost.com ([69.89.18.17]:42680 "HELO
	outbound-mail-48.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755874AbXEUP5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:57:55 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Mon, 21 May 2007 08:57:44 -0700
User-Agent: KMail/1.9.6
Cc: Dave Airlie <airlied@gmail.com>, Jon Smirl <jonsmirl@verizon.net>,
       Jesse Barnes <jesse.barnes@intel.com>, jonsmirl@gmail.com,
       linux-kernel@vger.kernel.org
References: <200705171423.46748.jesse.barnes@intel.com> <21d7e9970705210227x27234e2dme4e731a53f977082@mail.gmail.com> <46516A14.2000102@aitel.hist.no>
In-Reply-To: <46516A14.2000102@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705210857.44911.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Helge Hafting wrote:
> >> > TThe problem with that is the concept of heads is flawed... there
> >> > is in reality no such
> >> > thing, you have crtcs and outputs, no heads. So any attempt to
> >> > enforce the head concept involves putting policy into the kernel,
> >> > as if I have 3 outputs but 2 crtcs how do I decide the mappings
> >> > without the admin telling the kernel,
> >>
> >> Solution:
> >> One device per crtc. You can then have two users, running consoles
> >> or xservers on their crtcs, without having to involve root.
> >
> > Thats pretty much what the code does, but you still are putting a
> > certain amount of policy in the kernel...
>
> What policy would that be?
> The mapping is set by root from userspace, not by the kernel.
> The same for ownership to crtc devices. The kernel may have to
> provide some default so "init=/bin/sh" will work, that's all.

The policy of mapping outputs to CRTCs.  Like Dave said, you may have 
several outputs but only one or two CRTCs, with limitations on how they 
can be routed.  So doing "one device per CRTC" isn't quite enough, you 
also have to choose an initial output setup.  But like you say this could 
be changed at boot time.

> Sure.  Not multiseat by default, as the kernel can't know which output
> goes with which keyboard. All I want it a system that allows
> multiseat for those that care to set it up.

Sure, and like I mentioned to Jon in another mail, a decent multiseat setup 
is possible with these interfaces, albeit with a userlevel graphics daemon 
to arbitrate what the CRTC->output mappings are and to coordinate access 
to the hw if needed.

So really, I think the interfaces posted here will do what you want.  Maybe 
you can take a closer look and make sure?

Thanks,
Jesse
