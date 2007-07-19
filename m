Return-Path: <linux-kernel-owner+w=401wt.eu-S940021AbXGSRHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940021AbXGSRHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbXGSRGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:06:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058AbXGSRGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:06:53 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH for review] [7/48] i386: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Date: Thu, 19 Jul 2007 19:06:49 +0200
User-Agent: KMail/1.9.6
Cc: wli@holomorphy.com, lkml@rtr.ca, linux-kernel@vger.kernel.org
References: <20070719348.540885000@suse.de> <20070719134836.0C54214E6E@wotan.suse.de> <20070719144631.GA14938@redhat.com>
In-Reply-To: <20070719144631.GA14938@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191906.49854.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 16:46:31 Dave Jones wrote:
> On Thu, Jul 19, 2007 at 03:48:36PM +0200, Andi Kleen wrote:

I didn't. If you guys really want to have a thread to criticize the changelog
(which seems quite bogus, after all we're interested in code here, 
not changelogs) then please at least get your attributions right.

Regarding highmem instability: there are still known ways to drive
systems with larger highmem ratios to early OOM or deadlock, although they
are relatively obscure.

-Andi

>  
>  > Some users may want NX
>  > or expanded swapspace support without the overhead or instability of
>  > highmem. 
> 
> NX is still going to need the larger PTEs, so I don't see how this
> change removes any 'overhead' or potential 'instability'.
> I'm not necessarily disagreeing with the change, but this part
> of the changelog seems to be false advertising.
> 
> 	Dave
> 


