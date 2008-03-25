Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYCYVD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYCYVD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbYCYVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:03:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760121AbYCYVDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:03:14 -0400
Message-ID: <47E96876.3050206@redhat.com>
Date: Tue, 25 Mar 2008 17:02:46 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, mingo@elte.hu, ak@suse.de,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Increase max physical memory size of x86_64
References: <20080321133157.GA10911@sgi.com> <20080325164154.GA5909@alberich.amd.com> <20080325165438.GA5298@sgi.com>
In-Reply-To: <20080325165438.GA5298@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner wrote:
> On Tue, Mar 25, 2008 at 05:41:54PM +0100, Andreas Herrmann wrote:
>> On Fri, Mar 21, 2008 at 08:31:57AM -0500, Jack Steiner wrote:
>>> Increase the maximum physical address size of x86_64 system
>>> to 44-bits. This is in preparation for future chips that
>>> support larger physical memory sizes.
>> Shouldn't this be increased to 48?
>> AMD family 10h CPUs actually support 48 bits for the
>> physical address.
> 
> You are probably correct but I don't work with AMD processors
> and don't understand their requirements. If someone
> wants to submit a patch to support larger phys memory sizes,
> I certainly have no objections....

The only advantage 44 bits has over 48 bits is that it allows us to uniquely 
identify 4k physical pages with 32 bits, potentially allowing for tighter 
packing of certain structures.  Do we have any code that does this, and if so, 
is it a worthwhile optimization?

Personally, I think we should support the full capability of the hardware, but I 
don't have a 17 TB Opteron box to test with.

-- Chris
