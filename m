Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZIAHOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZIAHOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZIAHOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:14:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:43745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZIAHOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:14:52 -0400
Message-ID: <4A9CC9E9.2070609@kernel.org>
Date: Tue, 01 Sep 2009 16:14:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: boot panic after oops from sysfs_new_dirent
References: <Pine.SOC.4.64.0908311646150.20934@math.ut.ee> <20090831.142215.111904849.davem@davemloft.net> <Pine.SOC.4.64.0909011003460.10184@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0909011003460.10184@math.ut.ee>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 01 Sep 2009 07:14:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
>>> I powered on my 6-CPU E3000 after a summer pause and tried todays 
>>> 2.6.31-rc8+git on it. It fails - first it spills lots of warnings about 
>>> percpu things, then oopses in sysfs_new_dirent and then panics.
> 
> Bisecting shows that there may be different crashes, like in
> 56513ed50cc8a5c184a3f347e81d74c850cc14fa below:

Yeah, I was trying to fix that one with
74d46d6b2d23d44d72c37df4c6a5d2e782f7b088 and it seemingly fixed it on
my machine.  Apparently broken on yours.  Are the errors different
before and after 74d46d6b2d?

Thanks.

-- 
tejun
