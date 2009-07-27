Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZG0FgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZG0FgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZG0FgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:36:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbZG0FgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:36:12 -0400
Cc: Avi Kivity <avi@redhat.com>,
       LKML Mailing List <linux-kernel@vger.kernel.org>,
       Sid Boyce <sboyce@blueyonder.co.uk>, KVM list <kvm@vger.kernel.org>
Message-Id: <8CF02BC9-C112-422B-A9D7-9B391F6EA694@suse.de>
From: Alexander Graf <agraf@suse.de>
To: g3vbv@blueyonder.co.uk
In-Reply-To: <4A6CD1AD.6090009@blueyonder.co.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: OpenSolaris boot failure with KVM and VirtualBox
Date: Mon, 27 Jul 2009 07:36:10 +0200
References: <4A5ED714.7010304@blueyonder.co.uk> <4A6C80C3.8090007@redhat.com> <4A6C9D1F.3090404@blueyonder.co.uk> <4A6C9DE6.8080002@redhat.com> <4A6CD1AD.6090009@blueyonder.co.uk>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.07.2009, at 23:59, Sid Boyce wrote:

> On 26/07/09 19:18, Avi Kivity wrote:
>> On 07/26/2009 09:14 PM, Sid Boyce wrote:
>>>
>>>> Is this a regression from previous kernel versions?  What  
>>>> userspace are
>>>> you using?
>>>>
>>>>
>>>
>>> Currently running 2.6.31-rc4 with the original kqemu-1.4.0pre1 on
>>> openSUSE 11.2 Milestone 4 and it boots OK - a 200G disk image used.
>>> qemu-system-x86_64 -cdrom /ISO/osol-0906-ai-x86.iso -boot d
>>> /osol0906.qcow2 -smp 4 -m 500M&
>>>
>>
>> Wait, are you using kqemu or kvm?
>>
>
> # l /dev/kvm
> crw-rw----+ 1 root root 10, 232 2009-07-24 20:26 /dev/kvm
> # lsmod|grep kvm
> kvm_amd                41908  0
> kvm                   180488  1 kvm_amd
>
> From long ago I read that kvm needed kqemu, so I have always built the
> module, but I see here it's not used.
> lsmod|grep qemu
> kqemu                 173496  0
>
> # rpm -qf /usr/bin/qemu-system-x86_64
> qemu-0.10.1-2.21

You're not using KVM. "Qemu" is the non-KVM version.

Maybe uli activated the preliminary kvm support in there, but if you  
want the real deal, install the "kvm" package and use /usr/bin/qemu-kvm.

Alex

