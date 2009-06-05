Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZFELVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZFELVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZFELVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:21:07 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40229 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZFELVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:21:06 -0400
Message-ID: <4A28FF76.7050104@s5r6.in-berlin.de>
Date: Fri, 05 Jun 2009 13:20:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Pranith Kumar <pranith.hacks@gmail.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Are patches for warnings in drivers/staging/* worth?
References: <4A28B566.1010105@gmail.com>
In-Reply-To: <4A28B566.1010105@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar wrote:
> Hi Greg,
> 
> I am looking at the various warnings which occur while compiling the 
> staging drivers. Most of them are
> 
> * unused variables
> * arg makes pointer from integer without cast
> * un-initialized variable
> 
> What in these warnings should I send patches against?

I'm not Greg, but --- I'd say it's the same as with all other kernel code:

  - If somebody else already actively works on the code in question,
    coordinate your efforts with him.  (I suppose Greg as the maintainer
    will tell you if there is parallel effort and whether /he/ will
    merge your patches, or the other developer should pick them up, or
    whatever.)¹

  - The goal of such patches should not just be about making the
    warnings go away, they should be about improving the code:  Fix
    bugs, make it more readable, eventually optimize...  I for one agree
    with the people who say that "fixing" the warnings without
    addressing the /underlying/ problems or even just the /surrounding/
    problems is actually very counterproductive.  Warnings are good!²
    They tell us that there probably is a problem.  As long as the
    problem is there, the warning should stay there.

> Are they worth the effort?

Most certainly, because getting the drivers merge-ready is exactly the
main purpose of carrying them in the staging area.


¹) For coordination between those who work on the staging drivers, there
is also linuxdriverproject.org's devel mailinglist.

²) Well, warnings are /not/ good if they become overwhelming noise.  But
at least the staging drivers are out of the picture of normal kernel
configurations, therefore they normally don't add noise.
-- 
Stefan Richter
-=====-==--= -==- --=-=
http://arcgraph.de/sr/
