Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYKGG3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYKGG3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbYKGG2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:28:41 -0500
Received: from kroah.org ([198.145.64.141]:48957 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755596AbYKGG2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:28:39 -0500
Date: Thu, 6 Nov 2008 22:17:00 -0800
From: Greg KH <greg@kroah.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Matthew Wilcox <matthew@wil.cx>, H L <swdevyid@yahoo.com>,
       Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, linux-pci@vger.kernel.org,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, mingo@elte.hu, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081107061700.GD3860@kroah.com>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <20081106174741.GC11773@parisc-linux.org> <20081106175308.GA17027@kroah.com> <49137255.9010104@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49137255.9010104@codemonkey.ws>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:40:21PM -0600, Anthony Liguori wrote:
> Greg KH wrote:
>> On Thu, Nov 06, 2008 at 10:47:41AM -0700, Matthew Wilcox wrote:
>>   
>>> I don't think we really know what the One True Usage model is for VF
>>> devices.  Chris Wright has some ideas, I have some ideas and Yu Zhao has
>>> some ideas.  I bet there's other people who have other ideas too.
>>>     
>>
>> I'd love to hear those ideas.
>>   
>
> We've been talking about avoiding hardware passthrough entirely and
> just backing a virtio-net backend driver by a dedicated VF in the
> host.  That avoids a huge amount of guest-facing complexity, let's
> migration Just Work, and should give the same level of performance.

Does that involve this patch set?  Or a different type of interface.

thanks,

greg k-h
