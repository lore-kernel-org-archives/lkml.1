Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0BQSqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:46:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:23505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0BQSqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:46:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=wL6Mb8vuF9DWg6TNgtFBCjoGepcAa0TwHxmjicdWYUT2zUzHy52+ZPva2yIIJDTZlo
         I3rVOhgBT1IPEGkoY6VRO3JQ7MPEbfl6n0sBHYLgW1WLVss9L8cv7fTTQq4RwaTdsPSa
         RmavfOTWx+0TFLwzLjSilQIU1Ka1CReyMsJyw=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 19:46:08 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.12r4; KDE/4.4.0; x86_64; ; )
Cc: david@lang.hm, Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com> <201002171927.07051.volkerarmin@googlemail.com> <20100217183703.GA15446@emergent.ellipticsemi.com>
In-Reply-To: <20100217183703.GA15446@emergent.ellipticsemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002171946.09884.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch 17 Februar 2010, Nick Bowler wrote:
> On 19:27 Wed 17 Feb     , Volker Armin Hemmann wrote:
> > On Mittwoch 17 Februar 2010, Nick Bowler wrote:
> > > On 09:41 Wed 17 Feb     , david@lang.hm wrote:
> > > > for a distro that is trying to make one kernel image run on every
> > > > possible type of hardware features like initramfs (and udev,
> > > > modeules, etc) are wonderful.
> > > > 
> > > > however for people who run systems that are known ahead of time and
> > > > static (and who build their own kernels instead of just relying on
> > > > the distro default kernel), all of this is unnessesary complication,
> > > > which leaves more room for problems to creep in.
> > > 
> > > Such people can easily construct an initramfs containing busybox and
> > > mdadm with a shell script hardcoded to mount their root fs and run
> > > switch_root.  It's a ~10 minute jobbie that only needs to be done once.
> > 
> > and even better when you don't have to do that one time job at all.
> 
> But people who are building their own kernels are already doing a
> (much harder, imo) one time job of configuring their kernels.
> 
> > btw, what about additional delay?
> 
> It takes about half a second for mdadm to assemble my root array, is
> that what you're referring to?
> 
> I assume that kernel auto-assembly is no faster, although I've never
> used it.  Regardless, half a second isn't very long to wait.

well at the moment it takes less than two seconds until init takes over.

Adding .5 seconds is a lot. And loading the initrd and changing root isn't 
free either, true?

I remember well all the noise in the past about making linux booting faster. 
So why slow it down with an initrd - especially if you can do without?

Glück Auf,
Volker
