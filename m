Return-Path: <linux-kernel-owner+w=401wt.eu-S933884AbXEPTfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbXEPTfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbXEPTew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:34:52 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:56680 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbXEPTev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:34:51 -0400
Date: Wed, 16 May 2007 21:28:07 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  8/14] Union-mount lookup
In-Reply-To: <20070516050851.GB4403@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705162127080.9019@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094218.GJ4139@in.ibm.com>
 <Pine.LNX.4.61.0705150937590.9570@yvahk01.tjqt.qr> <20070516050851.GB4403@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16 2007 10:38, Bharata B Rao wrote:
>> 
>> >+lookup_union:
>> >+	do {
>> >+		struct vfsmount *mnt = find_mnt(topmost);
>> >+		UM_DEBUG_DCACHE("name=\"%s\", inode=%p, device=%s\n",
>> >+				topmost->d_name.name, topmost->d_inode,
>> >+				mnt->mnt_devname);
>> >+		mntput(mnt);
>> >+	} while (0);
>> 
>> Why the extra do{}while? [elsewhere too]
>
>Not sure, may be to get a scope to define 'mnt' here. Jan ?

What I was implicitly suggesting that mnt could be moved into the
normal 'function scope'.


	Jan
-- 
