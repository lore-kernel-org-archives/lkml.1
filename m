Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYATNZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYATNZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYATNZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:25:01 -0500
Received: from metamail-vm.metaparadigm.com ([203.117.131.43]:58515 "EHLO
	metamail-vm.metaparadigm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbYATNZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:25:00 -0500
X-Greylist: delayed 896 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 08:25:00 EST
Message-ID: <47934820.7020209@metaparadigm.com>
Date: Sun, 20 Jan 2008 21:09:52 +0800
From: Michael Clark <michael@metaparadigm.com>
Organization: Metaparadigm Pte Ltd
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: hi-res mtime userspace interface
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there an existing linux userspace interface for accessing the 
microsecond or nanosecond level (a|m|c)times of filesystems that support 
them (e.g. ext4, xfs)? and possibly also the generation counters used by 
NFS.

I notice sys_utimes is able to set microsecond (c|a|m)times but I can't 
find an associated interface to read them (I've googled to no avail).

(also noticing freebsd and darwin's struct stat contains struct timespec 
for these as well as an st_gen field - although I do realise how 
incredibly difficult it would be to add these to linux's struct stat).

~mc

