Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYIOOBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYIOOBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 10:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYIOOBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 10:01:09 -0400
Received: from the.earth.li ([217.147.81.2]:40294 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYIOOBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 10:01:07 -0400
Date: Mon, 15 Sep 2008 14:30:26 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fixup deb-pkg target to generate separate firmware deb.
Message-ID: <20080915133026.GB18246@earth.li>
References: <20080912112042.GX30927@earth.li> <200809131035.18477.elendil@planet.nl> <20080913160831.GE30927@earth.li> <200809131828.54286.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809131828.54286.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 06:28:53PM +0200, Frans Pop wrote:
> On Saturday 13 September 2008, Jonathan McDowell wrote:
> > Ta, I've fixed both the indents. I've also changed the firmware package
> > to be arch: all.
> 
> Although I agree that arch all is technically not incorrect, I wonder if 
> it is the smart thing to do it here.
> 
> The pkg-deb target is probably mostly, or even exclusively - used to build 
> custom kernels, and people might be crossbuilding kernels with different 
> configs and thus resulting in different firmware files from the same 
> source (thus same version) on the same system.
> I build amd64, i386 and armel that way on my main desktop system, all with 
> different configs (tuned mainly to keep the build time down).
> 
> Keeping the firmware package arch-specific would ensure that a firmware 
> package built with the config for one arch does not get overwritten by 
> one built for another arch with a different config.

There's nothing stopping you having several different configs for the
same arch that don't produce all the required firmware either. I think
the right answer if you're building lots of different kernels for
different machines in testing is probably to build a
linux-firmware-image that has everything in it, so that you don't have
to worry about upgrading it most of the time.

(Technically you could make the firmware image indicate which firmware
it provides, but I think that gets overly granular for not huge gain.)

J.

-- 
Web [                        Make friends.                         ]
site: http:// [                                          ]       Made by
www.earth.li/~noodles/  [                      ]         HuggieTag 0.0.23
