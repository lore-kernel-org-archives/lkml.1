Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZHFNwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZHFNwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZHFNwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:52:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56710 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbZHFNwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:52:13 -0400
Message-ID: <4A7AE150.7040009@redhat.com>
Date: Thu, 06 Aug 2009 16:57:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: alacrityvm-devel@lists.sourceforge.net,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090806081955.GA9752@redhat.com> <4A7A8F7B0200005A00051B84@sinclair.provo.novell.com> <4A7AD29E.50800@redhat.com> <4A7A9C6B0200005A00051BB9@sinclair.provo.novell.com> <4A7ADE23.5010208@redhat.com> <4A7AA63A0200005A00051BE2@sinclair.provo.novell.com>
In-Reply-To: <4A7AA63A0200005A00051BE2@sinclair.provo.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2009 04:45 PM, Gregory Haskins wrote:
>
>> (though still rooting for virtio).
>>      
>
> Heh...not to belabor the point to death, but virtio is orthogonal (you keep forgetting that ;).
>
> Its really the vbus device-model vs the qemu device-model (and possibly vs the "in-kernel pci emulation" model that I believe Michael is working on).
>
> You can run virtio on any of those three.
>    

It's not orthogonal.  virtio is one set of ABI+guest drivers+host 
support to get networking on kvm guests.  AlacrityVM's vbus-based 
drivers are another set of ABI+guest drivers+host support to get 
networking on kvm guests.  That makes them competitors (two different 
ways to do one thing), not orthogonal.

-- 
error compiling committee.c: too many arguments to function

