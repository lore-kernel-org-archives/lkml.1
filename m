Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYF3CwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYF3CwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 22:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYF3Cv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 22:51:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59281 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYF3Cvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 22:51:55 -0400
Message-ID: <48684A46.7040802@garzik.org>
Date: Sun, 29 Jun 2008 22:51:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Jan Engelhardt <jengelh@computergmbh.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Updated Kernel Hacker's guide to git
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl> <476E42BF.1010300@garzik.org> <Pine.LNX.4.64.0712310349260.2093@fbirervta.pbzchgretzou.qr> <4778D1CD.4020001@s5r6.in-berlin.de>
In-Reply-To: <4778D1CD.4020001@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Jan Engelhardt wrote:
>>> 	http://linux.yyz.us/git-howto.html
>> It says
>>
>> """Don't forget to download tags from time to time.
>>
>> git pull only downloads sha1-indexed object data, and the requested
>> remote head. This misses updates to the .git/refs/tags/ and
>> .git/refs/heads/ directories. For tags, run git fetch --tags $URL."""
>>
>> But when I do git pull on a simple tracking tree (e.g. git-clone
>> torvalds/linux-2.6.git; git pull;) it automatically grabs new tags.
> 
> A while ago the default behavior of git pull was changed to fetch all
> tags which point to objects that can be reached from any of the tracked
> heads.


This does not work in all cases.  When I retrieve the latest kernel, it 
downloads the tags:

	cd /spare/repo/linux-2.6
	git pull

but when I pull those changes into another local repo, the tags do -not- 
follow the objects:

	cd /spare/repo/misc-2.6
	git checkout master
	git pull ../linux-2.6
	git fetch --tags ../linux-2.6	# still required to this day

Regards,

	Jeff



