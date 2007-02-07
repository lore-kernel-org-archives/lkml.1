Return-Path: <linux-kernel-owner+w=401wt.eu-S965696AbXBGSFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965696AbXBGSFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422635AbXBGSFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:05:50 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:41179 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965660AbXBGSFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:05:49 -0500
Date: Wed, 7 Feb 2007 19:03:05 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
In-Reply-To: <20070207072259.GA22083@lst.de>
Message-ID: <Pine.LNX.4.61.0702071901150.20245@yvahk01.tjqt.qr>
References: <20070206132333.GA9919@lst.de> <20070206155001.22ab74f6.akpm@linux-foundation.org>
 <20070207072259.GA22083@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 7 2007 08:22, Christoph Hellwig wrote:

>> That loop has (and had) up to O(n^n) operations.  Is there something which
>> prevents this from going insane?
>
>I don't think so.  Then again it's only called when you call quotaon on
>a mounted filesystem, and normally you don't have that many inodes
>instanciated at that time.

With filesystems that can turn on their quota after mount time (about 
every fs except xfs), I can surely have a ton of files open, and hence, 
if I understand correctly, have lots of inodes instantiated.


Jan
-- 
