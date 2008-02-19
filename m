Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbYBSVzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbYBSVzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761362AbYBSVzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:55:09 -0500
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:3367 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761271AbYBSVzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:55:07 -0500
From: Frans Pop <elendil@planet.nl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Unable to continue testing of 2.6.25
Date: Tue, 19 Feb 2008 22:55:01 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200802171025.30590.elendil@planet.nl> <20080217131611.GA1403@cs181133002.pp.htv.fi>
In-Reply-To: <20080217131611.GA1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192255.02152.elendil@planet.nl>
X-OriginalArrivalTime: 19 Feb 2008 21:55:02.0967 (UTC) FILETIME=[1489CC70:01C87342]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008, Adrian Bunk wrote:
> The real problem is that the kernel seems to lack functionality you
> require for doing some work.

Not sure how you reached that conclusion.

> Why does your work on the Debian Installer depend on VirtualBox and
> can't be done with what the kernel already ships?

Work on the installer does not so much hard depend on VirtualBox (or any 
other emulator), but can be done much more effectively and efficiently 
using one.

It allows me to run the installer inside the emulator without the need for a 
second computer (and using the same keyboard). It allows me to take 
snapshots just before stages I'm interested in and then add debugging or 
try changes. If what I tried does not work, I can just revert to the 
snapshot and try something else without having to run the full installation 
from scratch. It allows me to easily test RAID setups without having 
multiple physical disks. Etc.

The fact that VirtualBox does not (yet) work for me with 2.6.25 means that 
I'm unable to run 2.6.25 on my main desktop and do any real work. Rebooting 
my desktop whenever I want to use VirtualBox is just not a realistic 
option.
That in turn means that I cannot do any more testing of 2.6.25, because most 
of the testing I do consists of just using a new kernel and critically 
observing the behavior of my system. As I've caught a fair number of bugs 
that way for the past few releases, I'd say that's a useful contribution.
