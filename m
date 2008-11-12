Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbYKLJXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbYKLJXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYKLJW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:22:58 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57761 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYKLJW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:22:56 -0500
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Peter Zijlstra'" <peterz@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <virtualization@lists.linux-foundation.org>, <jens.axboe@oracle.com>,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, <ngupta@google.com>,
       <fernando@oss.ntt.co.jp>, <vtaras@openvz.org>,
       "'Hirokazu Takahashi'" <taka@valinux.co.jp>,
       <balbir@linux.vnet.ibm.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>, <menage@google.com>,
       "'SUGAWARA Tomoyoshi'" <tom-sugawara@ap.jp.nec.com>,
       <paolo.valente@unimore.it>, "'Fabio Checconi'" <fabio@gandalf.sssup.it>
References: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com> <1226480279.7685.2980.camel@twins>
In-Reply-To: <1226480279.7685.2980.camel@twins>
Subject: RE: [PATCH][RFC][12+2][v3] A expanded CFQ scheduler for cgroups
Date: Wed, 12 Nov 2008 18:22:29 +0900
Message-ID: <000001c944a8$2f3867b0$8da93710$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclEpMnvEBuwO2gnRqiOZy5nkPKu0QAA1e2A
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter.

> Just wondering,.. have you lot looked at the recently posted BFQ
> patches?
> 
> BFQ looks like a very promising elevator, its has tighter bounds than
> CFQ and already does the cgroup thing.


This patchset is improved our previous scheduler(sent 04/01/2008) and resolves some problems.

And, we scheduler can control at the two layers.
Namely, it can control I/O among groups and I/O among tasks within a group.

I always check in containers ML mainly.
So, I found I/O control patches in it ML, dm-iobnd, io-throttle, Naveen's Anticipatory I/O scheduler,
Vasily's CFQ scheduler and Vivek's Another IO controller.
And today I know the BFQ scheduler, so I'm not looked at the BFQ yet.
Now, I'm looking its patch.

Thanks, comments.


Satoshi UCHIDA


> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, November 12, 2008 5:58 PM
> To: Satoshi UCHIDA
> Cc: linux-kernel@vger.kernel.org;
> containers@lists.linux-foundation.org;
> virtualization@lists.linux-foundation.org; jens.axboe@oracle.com; 'Ryo
> Tsuruta'; 'Andrea Righi'; ngupta@google.com; fernando@oss.ntt.co.jp;
> vtaras@openvz.org; 'Hirokazu Takahashi'; balbir@linux.vnet.ibm.com;
> 'Andrew Morton'; menage@google.com; SUGAWARA Tomoyoshi;
> paolo.valente@unimore.it; Fabio Checconi
> Subject: Re: [PATCH][RFC][12+2][v3] A expanded CFQ scheduler for cgroups
> 
> Hi,
> 
> Just wondering,.. have you lot looked at the recently posted BFQ
> patches?
> 
> BFQ looks like a very promising elevator, its has tighter bounds than
> CFQ and already does the cgroup thing.
> 


> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, November 12, 2008 5:58 PM
> To: Satoshi UCHIDA
> Cc: linux-kernel@vger.kernel.org;
> containers@lists.linux-foundation.org;
> virtualization@lists.linux-foundation.org; jens.axboe@oracle.com; 'Ryo
> Tsuruta'; 'Andrea Righi'; ngupta@google.com; fernando@oss.ntt.co.jp;
> vtaras@openvz.org; 'Hirokazu Takahashi'; balbir@linux.vnet.ibm.com;
> 'Andrew Morton'; menage@google.com; SUGAWARA Tomoyoshi;
> paolo.valente@unimore.it; Fabio Checconi
> Subject: Re: [PATCH][RFC][12+2][v3] A expanded CFQ scheduler for cgroups
> 
> Hi,
> 
> Just wondering,.. have you lot looked at the recently posted BFQ
> patches?
> 
> BFQ looks like a very promising elevator, its has tighter bounds than
> CFQ and already does the cgroup thing.
> 


