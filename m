Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbXJQGTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbXJQGTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJQGTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:19:09 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:21559 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbXJQGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:19:07 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 02:19:07 EDT
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Distinguishing releases from pre-rc snapshots
Cc: linux-kernel@vger.kernel.org
In-reply-To: <1192587763.3672.24.camel@dv>
References: <1192587763.3672.24.camel@dv>
Message-Id: <E1Ii1zU-0002Cj-EC@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 17 Oct 2007 08:02:48 +0200
X-OriginalArrivalTime: 17 Oct 2007 06:02:48.0645 (UTC) FILETIME=[58315F50:01C81083]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Roskin wrote:
> I'm trying to keep some external drivers up to date with the kernel, and
> the first two weeks after the release is the worst time for me.  There
> is no way to distinguish the current git kernel from the latest release.
> It's only after rc1 is released that I can use preprocessor to check
> LINUX_VERSION_CODE.
> 
> Before that, I have to rely on tricks or change the kernel version
> myself in a separate patch and tell other team members to do the same.
 
Note that you can see if there have been commits since a release (the last git tag) by using the command 'git describe'.

$ git checkout -b temp v2.6.23
Switched to a new branch "temp"
$ git describe
v2.6.23
$ git checkout master
$ git describe
v2.6.23-4223-g65a6ec0

Format is: last tag - # commits since last tag - id of HEAD commit

Hope this helps,
Frans Pop
