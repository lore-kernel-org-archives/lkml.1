Return-Path: <linux-kernel-owner+w=401wt.eu-S934367AbZDAUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934367AbZDAUlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbZDAUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:41:04 -0400
Received: from sous-sol.org ([216.99.217.87]:53094 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753307AbZDAUlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:41:03 -0400
Date: Wed, 1 Apr 2009 13:40:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Andi Kleen <andi@firstfloor.org>, Gregory Haskins <ghaskins@novell.com>,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090401204039.GR18394@sequoia.sous-sol.org>
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com> <20090401132340.GT11935@one.firstfloor.org> <49D37805.1060301@novell.com> <20090401170103.GU11935@one.firstfloor.org> <49D3B64F.6070703@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D3B64F.6070703@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
> Andi Kleen wrote:
>> On Wed, Apr 01, 2009 at 10:19:49AM -0400, Gregory Haskins wrote:
>>> Performance.  We are trying to create a high performance IO infrastructure.
>>
>> Ok. So the goal is to bypass user space qemu completely for better
>> performance. Can you please put this into the initial patch
>> description?
>
> FWIW, there's nothing that prevents in-kernel back ends with virtio so  
> vbus certainly isn't required for in-kernel backends.

Indeed.

> That said, I don't think we're bound today by the fact that we're in  
> userspace.  Rather we're bound by the interfaces we have between the  
> host kernel and userspace to generate IO.  I'd rather fix those  
> interfaces than put more stuff in the kernel.

And more stuff in the kernel can come at the potential cost of weakening
protection/isolation.
