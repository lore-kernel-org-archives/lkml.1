Return-Path: <linux-kernel-owner+w=401wt.eu-S1764209AbXKNGSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764209AbXKNGSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760488AbXKNGSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:18:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:45596 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432AbXKNGSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:18:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Aa/TlgPRHZSsnmm5X3nCP7IuEocDUVpZ3VL1LOL6LEK3TumQQSl2go57d88eWR/GRduY1GK+jbNTTU2/VuNNEE6mVHV0lVo1+zr2mb+sgR8xwiAMSjz+ml4GOD4bGl4OiSyDRXZJEYW9feSe5r0xLXzta4HbT2Q7nZzYUZOsyAs=
Message-ID: <a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
Date: Wed, 14 Nov 2007 14:18:39 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc2-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Boot failed on my machine. hand copy some messages.

First with BLK_DEV_RAM=y

BUG kmalloc-64 Poison overwritting:
Alloced in kset_create
Freed in kobject_cleanup

--cut--
alloc_disk_node
rd_init
kernel_init
--cut--

Then config ramdisk as module, build and reboot:

BUG: unable handle paging resuest at 6b6b6b6b
EIP is kobject_add 0xc4/0x150

--cut--
kobject_set_name
register_disk
add_disk
exact_match
exact_lock
loop_init
--cut--

Regards
dave
--cut--
