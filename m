Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbYD2QrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbYD2QrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbYD2Qqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:46:53 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:40698 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYD2Qqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:46:53 -0400
Message-ID: <48175005.90400@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2008 22:12:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ross Biro <rossb@google.com>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: Page Faults slower in 2.6.25-rc9 than 2.6.23
References: <d43160c70804290610t2135a271hd9b907529e89e74e@mail.gmail.com> <Pine.LNX.4.64.0804291447040.5058@blonde.site> <661de9470804290752w1dc0cfb3k72e81d828a45765e@mail.gmail.com> <d43160c70804290821i2bb0bc17m21b0c5838631e0b8@mail.gmail.com> <Pine.LNX.4.64.0804291629410.23101@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0804291629410.23101@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 29 Apr 2008, Ross Biro wrote:
>> On Tue, Apr 29, 2008 at 10:52 AM, Balbir Singh
>> <balbir@linux.vnet.ibm.com> wrote:
>>>  Hmm.. strange.. I don't remember the overhead being so bad (I'll
>>>  relook at my old numbers). I'll try and git-bisect this one
>> I'm checking 2.6.24 now.  A quick run of 2.6.25-rc9 without fake numa
>> showed no real change.
> 
> Worth checking 2.6.24, yes.  But you've already made it clear that
> you do NOT have mem cgroups in your 2.6.25-rc9, so Balbir (probably)
> need not worry about your regression: my guess was wrong on that.
> 

Aah.. Yes... but I am definitely interested in figuring out the root cause for
the regression.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
