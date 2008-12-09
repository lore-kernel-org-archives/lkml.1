Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYLINW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYLINW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 08:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYLINWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 08:22:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55054 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbYLINWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 08:22:47 -0500
Message-ID: <493E7122.5010904@redhat.com>
Date: Tue, 09 Dec 2008 15:22:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Sheng Yang <sheng@linux.intel.com>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] module_refcounting and anonymous inodes
References: <200812021114.59050.borntraeger@de.ibm.com> <200812091743.26586.sheng@linux.intel.com> <493E3F8B.7070603@redhat.com> <200812091108.39145.borntraeger@de.ibm.com> <493E452E.4020304@redhat.com>
In-Reply-To: <493E452E.4020304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Christian Borntraeger wrote:
>> The problem is, how do you detect if the base kernel has patch1 applied?
>>   
>
> In the external module compatibility kit, implement two versions of 
> anon_inode_getfd(), and select the appropriate one according to kernel 
> version (like we currently support 91 smp_call_function_single variants).
>

I committed something simpler:  if running on 2.6.28 or earlier, I hack 
out the two lines your second patch adds.\

-- 
error compiling committee.c: too many arguments to function

