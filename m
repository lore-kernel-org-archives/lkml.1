Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbZLPKz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbZLPKz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761270AbZLPKz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:55:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:49621 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbZLPKz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:55:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,405,1257148800"; 
   d="scan'208";a="579445192"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Avi Kivity <avi@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Wed, 16 Dec 2009 18:55:47 +0800
Subject: seabios question
Thread-Topic: seabios question
Thread-Index: Acp+PlKl1z+qjBU0THutL6k8mllVWg==
Message-ID: <EB8593BCECAB3D40A8248BE0B6400A382E9BF7D7@shzsmsx502.ccr.corp.intel.com>
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

Hi, Avi

Recently I want to update hvm vcpu add/remove feature of KVM.
I go through qemu-kvm, find that original boch vbios code (i.e, qemu-kvm/kvm/bios/acpi-dsdt.asl, ...) has been removed.

Now qemu-kvm use seabios git repo http://git.kernel.org/?p=virt/kvm/seabios.git;a=summary as its vbios, right?
If I want to update seabios dsdt logic, may I build and then copy seabios/out/bios.bin to qemu-kvm/pc-bios/bios.bin? 
and, I rebuild qemu-kvm and my update of seabios will take effect at kvm qemu side, right?

Thanks,
Jinsong