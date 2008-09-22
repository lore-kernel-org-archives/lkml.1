Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYIVObv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYIVObv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYIVObn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:31:43 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48321 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYIVObm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:31:42 -0400
Message-ID: <48D7AC44.6050208@bull.net>
Date: Mon, 22 Sep 2008 16:31:32 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: sysfs: tagged directories not merged completely yet
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Someone made me notice that Eric's "sysfs tagged directories" patchset
you merged recently  isn't complete in your "patches" tree. The last two
patches that actually uses this new feature aren't in your tree yet.

* [PATCH 7/8] netns: Enable tagging for net_class directories in sysfs
* [PATCH 8/8] sysfs: user namespaces: fix bug with clone(CLONE_NEWUSER)	
with fairsched

I didn't noticed it sooner because I'm still using my own version of the
patchset on top of linux-2.6.

I'm wondering why you left these two patches out? Is it on purpose? Do
you expect other maintainers to merged them in their respective tree?
Dave Miller acked the patch for network namespace and said "You can send
it all through Greg or whoever, don't feel obligated to push it through
me since it depends upon the earlier bits in this series".

Thanks.

Benjamin

-- 
B e n j a m i n   T h e r y  - BULL/DT/Open Software R&D

    http://www.bull.com
