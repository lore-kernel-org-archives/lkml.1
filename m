Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYKKJEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYKKJEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYKKJEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:04:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbYKKJEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:04:06 -0500
Message-ID: <491949A4.3060205@redhat.com>
Date: Tue, 11 Nov 2008 11:00:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Fischer, Anna" <anna.fischer@hp.com>, H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106180354.GA17429@kroah.com> <4916DB16.2040709@redhat.com> <20081109192505.GA3091@kroah.com> <49173BF0.5050506@redhat.com> <20081111060845.GB13025@kroah.com>
In-Reply-To: <20081111060845.GB13025@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

  

>> arch/x86/kvm/vtd.c: iommu integration (allows assigning the device's memory 
>> resources)
>>     
>
> That file is not in 2.6.28-rc4 :(
>
>   

Sorry, was moved to virt/kvm/ for ia64's benefit.

>   
>> virt/kvm/irq*: interrupt redirection (allows assigning the device's 
>> interrupt resources)
>>     
>
> I only see virt/kvm/irq_comm.c in 2.6.28-rc4.
>
>   

kvm_main.c in that directory also has some related bits.

>> the rest (pci config space, pio redirection) are in userspace.
>>     
>
> So you don't need these pci core changes at all?
>
>   

Not beyond those required for SR-IOV and iommu support.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

