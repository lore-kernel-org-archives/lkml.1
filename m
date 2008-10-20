Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYJTBSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYJTBSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 21:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYJTBSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 21:18:39 -0400
Received: from mail.anarazel.de ([217.115.131.40]:48393 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYJTBSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 21:18:39 -0400
From: Andres Freund <andres@anarazel.de>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
Date: Mon, 20 Oct 2008 03:18:37 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-04904-gc813b4e; KDE/4.1.2; x86_64; ; )
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie> <200810200300.01411.andres@anarazel.de> <alpine.DEB.0.82.0810200202270.27788@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.0.82.0810200202270.27788@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810200318.37337.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 20 October 2008 03:04:16 Dave Airlie wrote:
> > Hm. But still, there is at least one distribution (ubuntu intrepid) which
> > will propably will ship 2.4.1 in its stable version soon (it seems
> > unlikely that they will update to an unstable version just before an
> > release). Which means, that this driver will get quite some spread...
> Intel will give the fixes to Ubuntu to roll into 2.4.x hopefully.
I opened a bugreport on their bugtracker to make them aware of the issue:
https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/286182

> > Is it accepted that the kernel abi breaks that radically/fast?
> The problem is this isn't a kernel ABI at all. This is two pieces of code
> which are doing the exact same thing to a piece of hardware, one from the
> kernel and one from userspace. When they disagree things break, however
> sometimes when they agree things are broken.
Hm, I understand what you are saying, but I don't see a fundamental difference 
to an ABI here. But it doesn't matter anyway...


Andres

