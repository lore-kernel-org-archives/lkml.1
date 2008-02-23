Return-Path: <linux-kernel-owner+w=401wt.eu-S936184AbYBWBBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936184AbYBWBBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYBWBBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:01:06 -0500
Received: from lotis.site5.com ([74.53.58.75]:32977 "EHLO lotis.site5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYBWBBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:01:04 -0500
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 20:01:04 EST
From: Chase Venters <chase.venters@clientec.com>
To: linux-kernel@vger.kernel.org
Subject: Question about your git habits
Date: Fri, 22 Feb 2008 18:37:14 -0600
User-Agent: KMail/1.9.7
Cc: git@vger.kernel.org
Organization: Clientec, Inc.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802221837.37680.chase.venters@clientec.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - lotis.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - clientec.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been making myself more familiar with git lately and I'm curious what 
habits others have adopted. (I know there are a few documents in circulation 
that deal with using git to work on the kernel but I don't think this has 
been specifically covered).

My question is: If you're working on multiple things at once, do you tend to 
clone the entire repository repeatedly into a series of separate working 
directories and do your work there, then pull that work (possibly comprising 
a series of "temporary" commits) back into a separate local master 
respository with --squash, either into "master" or into a branch containing 
the new feature?

Or perhaps you create a temporary topical branch for each thing you are 
working on, and commit arbitrary changes then checkout another branch when 
you need to change gears, finally --squashing the intermediate commits when a 
particular piece of work is done?

I'm using git to manage my project and I'm trying to determine the most 
optimal workflow I can. I figure that I'm going to have an "official" master 
repository for the project, and I want to keep the revision history clean in 
that repository (ie, no messy intermediate commits that don't compile or only 
implement a feature half way).

On older projects I was using a certalized revision control system like 
*cough* Subversion *cough* and I'd create separate branches which I'd check 
out into their own working trees.

It seems to me that having multiple working trees (effectively, cloning 
the "master" repository every time I need to make anything but a trivial 
change) would be most effective under git as well as it doesn't require 
creating messy, intermediate commits in the first place (but allows for them 
if they are used). But I wonder how that approach would scale with a project 
whose git repo weighed hundreds of megs or more. (With a centralized rcs, of 
course, you don't have to lug around a copy of the whole project history in 
each working tree.)

Insight appreciated, and I apologize if I've failed to RTFM somewhere.

Thanks,
Chase
