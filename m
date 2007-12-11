Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXLKNjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXLKNjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXLKNjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:39:24 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:34570 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXLKNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:39:23 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [RFC] Proposed new directory layout for kvm and virtualization
Date: Tue, 11 Dec 2007 14:38:50 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
References: <475E5CBB.9080608@qumranet.com>
In-Reply-To: <475E5CBB.9080608@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712111438.51142.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 11. Dezember 2007 schrieb Avi Kivity:
> KVM is due to receive support for multiple architectures (ppc, ia64, and 
> s390, in addition to the existing x86), hopefully in time for the 2.6.25 
> merge window.  It is awkward to place the new arch support in 
> drivers/kvm/, so I'd like to propose the following new layout:
> 
>   virt/         top-level directory for hypervisors
>   virt/kvm/     kvm common code
>   virt/lguest/  the other hypervisor
>   arch/*/kvm/   arch dependent kvm code
>   include/linux/kvm.h       arch independent interface
>   include/asm/kvm.h         arch dependent interface
>   include/linux/kvm_para.h  arch independent guest interface
>   include/asm/kvm_para.h    arch dependent guest interface
> 
> The include/ hierarchy is already in place; I'm including it for 
> completeness.

For completeness, where do we want to put the drivers?
drivers/*, drivers/net/* etc. 
or
drivers/kvm/* drivers/xen/* etc.

Christian?
