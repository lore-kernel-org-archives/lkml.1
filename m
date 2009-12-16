Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbZLPK7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbZLPK7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbZLPK7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:59:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761270AbZLPK7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:59:15 -0500
Message-ID: <4B28BD80.7050407@redhat.com>
Date: Wed, 16 Dec 2009 12:59:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: seabios question
References: <EB8593BCECAB3D40A8248BE0B6400A382E9BF7D7@shzsmsx502.ccr.corp.intel.com>
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A382E9BF7D7@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 12:55 PM, Liu, Jinsong wrote:
> Hi, Avi
>
> Recently I want to update hvm vcpu add/remove feature of KVM.
> I go through qemu-kvm, find that original boch vbios code (i.e, qemu-kvm/kvm/bios/acpi-dsdt.asl, ...) has been removed.
>
> Now qemu-kvm use seabios git repo http://git.kernel.org/?p=virt/kvm/seabios.git;a=summary as its vbios, right?
> If I want to update seabios dsdt logic, may I build and then copy seabios/out/bios.bin to qemu-kvm/pc-bios/bios.bin?
> and, I rebuild qemu-kvm and my update of seabios will take effect at kvm qemu side, right?
>    

Correct.  You also need a 'make install', since qemu will pick up the 
bios from /usr/local/share/qemu/bios.bin.

-- 
error compiling committee.c: too many arguments to function

