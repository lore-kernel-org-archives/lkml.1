Return-Path: <linux-kernel-owner+w=401wt.eu-S1750738AbXBVKW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750738AbXBVKW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXBVKW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:22:59 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:41462 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbXBVKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:22:58 -0500
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Thu, 22 Feb 2007 11:22:28 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Dor Laor" <dor.laor@qumranet.com>
cc: "Avi Kivity" <avi@qumranet.com>, "Pavel Machek" <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers
 to a central arch-independent location
Message-ID: <20070222102228.GC12801@amd.com>
References: <45DD6CF0.3010509@qumranet.com>
 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>
MIME-Version: 1.0
In-Reply-To: <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Feb 2007 10:22:42.0713 (UTC)
 FILETIME=[63149090:01C7566B]
X-WSS-ID: 69C3B17C2X01161818-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 02:17:54AM -0800, Dor Laor wrote:
> I have Ingo's network PV hypercalls to commit in my piplien.
> Till then we can just add the test hypercall:
> 	case __NR_hypercall_test:
> 		printk(KERN_DEBUG "%s __NR_hypercall_test\n",
> __FUNCTION__);
> 		ret = 0x5a5a;
> 		break;
> 	default:
> 		BUG();

Is it a good idea to call BUG() on an undefined hypercall? I assume its
better to inform the guest that is has issued an illegal call...

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


