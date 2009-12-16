Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbZLPLBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbZLPLBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbZLPLBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:01:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbZLPLBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:01:43 -0500
Date: Wed, 16 Dec 2009 13:01:40 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Avi Kivity <avi@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: seabios question
Message-ID: <20091216110140.GB11219@redhat.com>
References: <EB8593BCECAB3D40A8248BE0B6400A382E9BF7D7@shzsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A382E9BF7D7@shzsmsx502.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 06:55:47PM +0800, Liu, Jinsong wrote:
> Hi, Avi
> 
> Recently I want to update hvm vcpu add/remove feature of KVM.
> I go through qemu-kvm, find that original boch vbios code (i.e, qemu-kvm/kvm/bios/acpi-dsdt.asl, ...) has been removed.
> 
> Now qemu-kvm use seabios git repo http://git.kernel.org/?p=virt/kvm/seabios.git;a=summary as its vbios, right?
> If I want to update seabios dsdt logic, may I build and then copy seabios/out/bios.bin to qemu-kvm/pc-bios/bios.bin? 
> and, I rebuild qemu-kvm and my update of seabios will take effect at kvm qemu side, right?
> 
Seabios not yet supports vCPU hot plug/unplug.

--
			Gleb.
