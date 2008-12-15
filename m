Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYLONPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYLONPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYLONPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 08:15:43 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58339 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYLONPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:15:42 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49465862.9090400@s5r6.in-berlin.de>
Date: Mon, 15 Dec 2008 14:15:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: devzero@web.de, Chris Mason <chris.mason@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: problem with git.kernel.org
References: <543076374@web.de>
In-Reply-To: <543076374@web.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
[I wrote]
>> The kernel repo is more than 100 times as big as this emerald repo, 400
>> times as big perhaps.  
> 
> yes, but http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git
> is a small repository, just containing the btrfs driver.

Right, I missed that.

...
>> Try to download with git.
> 
> i did, but it didn`t work either. i`m behind a http proxy.

Right again,
$ git clone \
http://www.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable-standalone.git
fails here after a few objects with
Cannot obtain needed blob ca442d313d86dc67e0a2e5d584b465bd382cbf5c
while processing commit 96dd95de14c77309abd2521d06c4825162b85e0a.
fatal: Fetch failed.

Chris, you should enable fetching over http by
$ cd /pub/scm/linux/kernel/git/mason/btrfs-unstable-standalone.git
$ cp -p hooks/post-update.sample hooks/post-update
Also run git-update-server-info unless you are pushing something soon
again anyway.

Cloning a full kernel repo over http may be too unreliable, but cloning
a smaller repo like the btrfs standalone repo should work acceptably
over http.
-- 
Stefan Richter
-=====-==--- ==-- -====
http://arcgraph.de/sr/
