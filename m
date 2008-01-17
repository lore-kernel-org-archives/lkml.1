Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYAQPii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYAQPii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYAQPi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:38:29 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:44720 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYAQPi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:38:27 -0500
In-Reply-To: <E1JFQWv-00061b-QA@pomaz-ex.szeredi.hu>
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu> <20080116143051.ec488f3d.akpm@linux-foundation.org> <20080116234339.GG26049@petra.dvoda.cz> <Pine.LNX.4.64.0801170057520.31385@fbirervta.pbzchgretzou.qr> <18318.41541.386224.301640@notabene.brown> <E1JFQWv-00061b-QA@pomaz-ex.szeredi.hu>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <88976638-FBF2-45CB-9ED3-500ED2623916@oracle.com>
Cc: neilb@suse.de, jengelh@computergmbh.de, kzak@redhat.com,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [patch] VFS: extend /proc/mounts
Date: Thu, 17 Jan 2008 10:36:24 -0500
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.753)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008, at 3:55 AM, Miklos Szeredi wrote:
>> Hey, I just found /proc/X/mountstats.  How does this fit in to the  
>> big
>> picture?
>
> It seems to show some counters for NFS mounts, no other filesystem
> uses it.  Format looks rather less nice, than /proc/X/mounts (why do
> we need long english sentences under /proc?).


I introduced /proc/self/mountstats because we need a way for non- 
block-device-based file systems to report I/O statistics.  Everything  
else I tried was rejected, and apparently what we ended up with was  
reviewed by only a handful of people, so no one else likes it or uses  
it.

It can go away for all I care, as long as we retain some flexible  
mechanism for non-block-based file systems to report I/O stats.  As  
far as I am aware, there are only two user utilities that understand  
and parse this data, and I maintain both.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
