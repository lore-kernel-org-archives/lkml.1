Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbYG2Rea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbYG2Rea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYG2ReW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:34:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33124 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752703AbYG2ReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:34:22 -0400
Date: Tue, 29 Jul 2008 12:34:20 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, steiner@sgi.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Comments on UV tlb flushing
Message-ID: <20080729173420.GA18296@sgi.com>
References: <488E644B.10801@goop.org> <200807291412.18495.nickpiggin@yahoo.com.au> <20080729133204.GA13138@sgi.com> <488F2C9B.9070306@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488F2C9B.9070306@goop.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 07:43:39AM -0700, Jeremy Fitzhardinge wrote:
> Cliff Wickman wrote:
>> I think that the Linux distributions are not going to build a special
>> UV kernel, are they?  So every distro would have to be prompted to  
>> turn on CONFIG_X86_UV, or else their kernel is not going to boot on UV.
>>   
>
> Distros will generally turn on everything.  You could have it on by  
> default if the kernel is built for CONFIG_X86_GENERICARCH which enables  
> support for other big numa configurations.  I think distros generally  
> build with that enabled anyway.
>
>    J

I don't know much about x86 configuration options.  It looks like
CONFIG_X86_GENERICARCH is fairly new, so I don't know where to look
for samples of how it will be set by RH and SuSE.

But if the tlb_uv.o code should be present in "every" distro x86 kernel
I don't see the point of having to configure it in.  Why not just
configure it out for small (embedded) kernels?

-Cliff
-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
