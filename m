Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYJVNTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYJVNTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYJVNTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:19:40 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:43875 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbYJVNTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:19:40 -0400
X-Greylist: delayed 1375 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 09:19:40 EDT
Message-ID: <48FF2304.8070301@dolphinics.no>
Date: Wed, 22 Oct 2008 14:56:36 +0200
From: Simen Thoresen <simentt@dolphinics.no>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: File as generic block-device?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a project where I require to treat a file as a block-device 
(specifically, I want a file on an ext3 fs to act as one of the 
raid-members in a md-based stripe-set. I know that I can make a 
/filesystem/ on a file because both mkfs and mount (with -o loop) will 
accept a file as a block-device, but I have found no such function for 
mdadm, and am thus asking for a kernel-internal way to re-plug a file 
into the block-device layer.

Is this possible?

My current platform i CentOS5, a RHEL5 rebuild (modified 2.6.18-kernel).

-S
-- 
Simen Thoresen - Dolphin ICS Systems Administrator
