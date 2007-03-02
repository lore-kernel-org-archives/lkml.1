Return-Path: <linux-kernel-owner+w=401wt.eu-S1422943AbXCBGEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422943AbXCBGEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422940AbXCBGEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:04:06 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60701 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422936AbXCBGED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:04:03 -0500
Message-ID: <45E7BE4B.5070602@us.ibm.com>
Date: Thu, 01 Mar 2007 22:03:55 -0800
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:0.9.4.1) Gecko/20020508 Netscape6/6.2.3
X-Accept-Language: en-us
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Amit K. Arora wrote:

>This is to give a heads up on few patches that we will be soon coming up
>with. These patches implement a new system call sys_fallocate() and a
>new inode operation "fallocate", for persistent preallocation. The new
>system call, as Andrew suggested, will look like:
>
>  asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
>
I am wondering about return values from this syscall ? Is it supposed to 
return the
number of bytes allocated ? What about partial allocations ? What about 
if the
blocks already exists ? What would be return values in those cases ?

Just curious .. What does posix_fallocate() return ?

Thanks,
Badari

>



