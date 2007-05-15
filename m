Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbXEOJgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbXEOJgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760088AbXEOJgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:36:15 -0400
Received: from mail.syneticon.net ([213.239.212.131]:46516 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952AbXEOJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:36:13 -0400
Message-ID: <46497EFD.6050900@wpkg.org>
Date: Tue, 15 May 2007 11:35:57 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: what does e2fsck's "non-contiguous" really say?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What does e2fsck's "non-contiguous" really say? I always thought it may 
give a clue about how a filesystem is fragmented.

However, I had set up a filesystem on a 365 GB RAID-5 array:

/dev/sdao             365G  195M  347G   1% /mnt/1


The filesystem contains only one directory (lost+found).

I ran e2fsck on that filesystem, and it says "9.1% non-contiguous":

# e2fsck -f part
e2fsck 1.39 (29-May-2006)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
part: 11/48594944 files (9.1% non-contiguous), 1574757/97187200 blocks


"9.1% non-contiguous" - what meaning does it really have?


-- 
Tomasz Chmielewski
http://wpkg.org
