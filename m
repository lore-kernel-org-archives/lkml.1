Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbYKIMut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbYKIMut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 07:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYKIMuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:50:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYKIMui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:50:38 -0500
Message-ID: <4916DBF7.7070501@redhat.com>
Date: Sun, 09 Nov 2008 14:47:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       "Fischer, Anna" <anna.fischer@hp.com>, Greg KH <greg@kroah.com>,
       H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106183630.GD11773@parisc-linux.org> <491371F0.7020805@codemonkey.ws> <20081106225854.GA15439@parisc-linux.org>
In-Reply-To: <20081106225854.GA15439@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
>> What we would rather do in KVM, is have the VFs appear in the host as 
>> standard network devices.  We would then like to back our existing PV 
>> driver to this VF directly bypassing the host networking stack.  A key 
>> feature here is being able to fill the VF's receive queue with guest 
>> memory instead of host kernel memory so that you can get zero-copy 
>> receive traffic.  This will perform just as well as doing passthrough 
>> (at least) and avoid all that ugliness of dealing with SR-IOV in the guest.
>>     
>
> This argues for ignoring the SR-IOV mess completely.

It does, but VF-in-host is not the only model that we want to support.  
It's just the most appealing.

There will definitely be people who want to run VF-in-guest.

-- 
error compiling committee.c: too many arguments to function

