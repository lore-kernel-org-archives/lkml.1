Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbZLPLGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbZLPLGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762019AbZLPLGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:06:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:49770 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762010AbZLPLGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:06:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="223470605"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Wed, 16 Dec 2009 19:05:28 +0800
Subject: RE: seabios question
Thread-Topic: seabios question
Thread-Index: Acp+Ps/s5g6LS0a7QeK7tBHt4Wg0kgAAF3RQ
Message-ID: <EB8593BCECAB3D40A8248BE0B6400A382E9BF7E2@shzsmsx502.ccr.corp.intel.com>
References: <EB8593BCECAB3D40A8248BE0B6400A382E9BF7D7@shzsmsx502.ccr.corp.intel.com>
 <4B28BD80.7050407@redhat.com>
In-Reply-To: <4B28BD80.7050407@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 12/16/2009 12:55 PM, Liu, Jinsong wrote:
>> Hi, Avi
>> 
>> Recently I want to update hvm vcpu add/remove feature of KVM.
>> I go through qemu-kvm, find that original boch vbios code (i.e,
>> qemu-kvm/kvm/bios/acpi-dsdt.asl, ...) has been removed. 
>> 
>> Now qemu-kvm use seabios git repo
>> http://git.kernel.org/?p=virt/kvm/seabios.git;a=summary as its
>> vbios, right?  
>> If I want to update seabios dsdt logic, may I build and then copy
>> seabios/out/bios.bin to qemu-kvm/pc-bios/bios.bin? and, I rebuild
>> qemu-kvm and my update of seabios will take effect at kvm qemu side,
>> right?  
>> 
> 
> Correct.  You also need a 'make install', since qemu will pick up the
> bios from /usr/local/share/qemu/bios.bin.

Thanks Avi :)

Jinsong