Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbZEFSpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbZEFSpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZEFSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:45:04 -0400
Received: from main.gmane.org ([80.91.229.2]:56949 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbZEFSpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:45:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lifesaver <ratin3@gmail.com>
Subject: DMI information from a kernel module?
Date: Wed, 6 May 2009 18:44:08 +0000 (UTC)
Message-ID: <loom.20090506T182838-226@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 128.107.241.170 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; InfoPath.2))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using kernel version 2.6.16.46.
I saw some code regarding dmi decoding in the kernel
source tree - arch/i386/kernel/dmi_scan.c. I believe 
dmi_scan_machine is done early in the boot process 
using bt_ioremap, dmi_alloc etc. Is it the case, 
and if yes, is there a way to get a hold of the 
stored information (via functions like dmi_get_system_info) 
from a dynamically loaded kernel module? 



