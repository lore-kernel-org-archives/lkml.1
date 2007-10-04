Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbXJDPvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbXJDPvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 11:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXJDPvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:51:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbXJDPvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:51:36 -0400
Message-ID: <47050BC5.6060306@redhat.com>
Date: Thu, 04 Oct 2007 11:50:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Document x86-64 iommu kernel parameters
References: <20071003013413.GA17717@havoc.gtf.org> <4703161E.8040603@zytor.com> <4703CA28.9010609@redhat.com> <200710041101.46794.ak@suse.de>
In-Reply-To: <200710041101.46794.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 05:01 AM, Andi Kleen wrote:
> 
> Well the x86-64 option was there first; you have to ask whoever
> added the i386 option why they used a different name
> 
> But I normally added aliases as people reported them. Nobody did in 
> this case.
> 
> One reason is probably that noapictimer is not very useful on x86-64 --
> the nolapic_timer is really more a workaround that only started making
> sense on HRT because it made "apicmaintimer" default. 
> On current x86-64 which doesn't do that there is very little reason to use it
> and you'll usually just break things.
> 

I have HRT in my x86_64 kernel. I guess that patchset should add the alias.
