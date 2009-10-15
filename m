Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbZJOF2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbZJOF2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 01:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZJOF2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 01:28:35 -0400
Received: from mail.lang.hm ([64.81.33.126]:54745 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZJOF2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 01:28:34 -0400
Date: Wed, 14 Oct 2009 22:27:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: removing existing working drivers via staging
Message-ID: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed this discussion in the thread "Moving drivers into 
staging (was Re: [GIT PULL] SCSI fixes for 2.6.32-" and I suspect that 
many others did as well

for those that missed it, as I understand it the proposal is that 'ugly' 
(working drivers that don't do things the kernel way and are perceived as 
not being commonly used anymore) drivers will get moved into staging, and 
if the driver maintainers do not clean them up within 6-9 months they will 
be removed entirely.

the expectation is that if there are no maintainers for the driver who 
care enough to do the cleanup they should be removed (with interested 
users being able to take over maintaining the drivers if there the 
maintainers are MIA)

I have several reactions to this

I think that 6-9 months (2-3 releases) is _far_ too short for users to 
notice. most users will be using a distro kernel that is on a release 
cycle longer than this (even if they are not using a 'enterprise' distro), 
so their first inkling of a problem will be the driver disappearing on 
them. Yes the driver can be recovered through git, bit at that point 
there is going to be catch-up changes to make.

What happened to the desire that Linux would be able to use anything, and 
once a driver was upstream changes to the kernel that would break it 
should be fixed by whoever is introducing those changes? This seems to be 
moving in the direction of only having drivers for fairly current, fairly 
common hardware.

David Lang
