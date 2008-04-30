Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbYD3IMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbYD3IMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYD3IML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:12:11 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:13343 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYD3IMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:12:09 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: small author mixup  (was: git pull KVM updates for 2.6.26rc)
Date: Wed, 30 Apr 2008 10:12:05 +0200
User-Agent: KMail/1.9.9
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>
References: <1209310768-12322-1-git-send-email-avi@qumranet.com>
In-Reply-To: <1209310768-12322-1-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804301012.05179.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 27. April 2008 schrieb Avi Kivity:
> Carsten Otte (4):
>       s390: KVM preparation: provide hook to enable pgstes in user pagetable
>       KVM: s390: interrupt subsystem, cpu timer, waitpsw
>       KVM: s390: API documentation
>       s390: KVM guest: detect when running on kvm
> 
> Christian Borntraeger (10):
>       KVM: kvm.h: __user requires compiler.h
>       s390: KVM preparation: host memory management changes for s390 kvm
>       s390: KVM preparation: address of the 64bit extint parm in lowcore
>       KVM: s390: sie intercept handling
>       KVM: s390: intercepts for privileged instructions
>       KVM: s390: interprocessor communication via sigp
>       KVM: s390: intercepts for diagnose instructions
>       KVM: s390: add kvm to kconfig on s390
>       KVM: s390: update maintainers
>       s390: KVM guest: virtio device support, and kvm hypercalls

Thats interesting, some of these patches should actually be credited to 
Carsten - and in fact on kvm.git master they are credited to Carsten.

I think the problem is, that these patches contained multiple From lines. On 
kvm.git the first line (Carsten) was used. When you transferred these patches 
to the kvm.git-2.6.26-branch, git used the next From-line as the original one 
was already removed.

While it is not a typical case, is there a better way of specifying multiple 
authors to avoid future confusion?

Christian
