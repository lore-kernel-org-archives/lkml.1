Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYKFWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYKFWkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYKFWka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:40:30 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:12487 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYKFWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:40:28 -0500
Message-ID: <49137255.9010104@codemonkey.ws>
Date: Thu, 06 Nov 2008 16:40:21 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Wilcox <matthew@wil.cx>, H L <swdevyid@yahoo.com>,
       Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, linux-pci@vger.kernel.org,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, mingo@elte.hu, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <20081106174741.GC11773@parisc-linux.org> <20081106175308.GA17027@kroah.com>
In-Reply-To: <20081106175308.GA17027@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Nov 06, 2008 at 10:47:41AM -0700, Matthew Wilcox wrote:
>   
>> I don't think we really know what the One True Usage model is for VF
>> devices.  Chris Wright has some ideas, I have some ideas and Yu Zhao has
>> some ideas.  I bet there's other people who have other ideas too.
>>     
>
> I'd love to hear those ideas.
>   

We've been talking about avoiding hardware passthrough entirely and just 
backing a virtio-net backend driver by a dedicated VF in the host.  That 
avoids a huge amount of guest-facing complexity, let's migration Just 
Work, and should give the same level of performance.

Regards,

Anthony Liguori

> Rumor has it, there is some Xen code floating around to support this
> already, is that true?
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

