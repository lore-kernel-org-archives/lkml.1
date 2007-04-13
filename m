Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbXDMCTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbXDMCTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXDMCTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:19:07 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:26963 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752223AbXDMCTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:19:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=pAOGTz1x1VM9pShWPdgEJAHAPzYCEvQ5pbaVQBUC43Ca81L8gH96y4czglk0Dk1E+B77Vk9WcJ+N+unVusWmhjDnQtgBEw689cL0rIWA5bESmiX0WtfNhPAmQSasaYgWALuDL5bRQrSn4Tl80hGQpLs4CYC+ZDCanXw6RUYp7vM=  ;
X-YMail-OSG: N_aNdmAVM1nvsNTxlfICJOmM7wH87k3p_nMMahinlZT_ftaQSZCTrSrt2Vf63v8Ga9Gu.RmZ0A--
Message-ID: <461EE890.2040601@yahoo.com.au>
Date: Fri, 13 Apr 2007 12:18:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com>	<20070412231050.GN2986@holomorphy.com>	<20070412163235.dd030637.akpm@linux-foundation.org>	<461ECB9C.8060000@yahoo.com.au>	<20070412174201.065068b2.akpm@linux-foundation.org>	<461ED96C.5030606@yahoo.com.au>	<20070412182213.a18cc4a7.akpm@linux-foundation.org>	<461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org>
In-Reply-To: <20070412185723.5a5f0443.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 13 Apr 2007 11:42:29 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

>>Maybe. How about LRU? Reclaim performance is bad, and you want to work out
>>which pages keep going off the end of it, or which pages keep getting
>>written out via it, or who's pages are on the active list, forcing mine
>>out.
> 
> 
> I guess we have static analysis versus dynamic.  The interfaces which Matt
> is proposing are suited to answering the question "what is my memory being
> used for" (static).  They're unlikely to be useful for answering the question
> "what's happening in the VM" (dynamic).  Systemtap is probably better for the
> dynamic analysis.

"what is my memory being used for *now*" ;)


> I guess one could generate an answer to the static question with systemtap,
> by accumulating running counts across the application lifetime and then
> snapshotting them.  Sounds hard though.

Can't you just traverse arbitrary kernel data structures at a given point
in time, exactly like the /proc/ call is doing?

-- 
SUSE Labs, Novell Inc.
