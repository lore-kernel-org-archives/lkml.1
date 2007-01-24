Return-Path: <linux-kernel-owner+w=401wt.eu-S965639AbXAXDA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639AbXAXDA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 22:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965638AbXAXDA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 22:00:58 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:31090 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965637AbXAXDA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 22:00:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0dAn0jX2rKd8tNBuBK8gcsF7yqTBUQztZs+sLweNAlKU2IQ1lGeSV8aAJthVcykLF/aXxncGHpSmE/yukDN1CX0Rxh3nctuEELMsqw3KZEO7Ks1vn/oncIImLqviztg4d0z6C3cqNe5XaJCM6S+Xb8bF/0gbOYkfROHGntAqx6c=  ;
X-YMail-OSG: 2_78fiYVM1mYdO9urtefrz3T2FuOPlSX8e8Jl.yH7xD.AaqTJ3p92aX.oamlx9G4A4EKZuBSUg--
Message-ID: <45B6CBD9.80600@yahoo.com.au>
Date: Wed, 24 Jan 2007 14:00:41 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Aubrey Li <aubreylee@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> This is a patch using some of Aubrey's work plugging it in what is IMHO 
> the right way. Feel free to improve on it. I have gotten repeatedly 
> requests to be able to limit the pagecache. With the revised VM statistics 
> this is now actually possile. I'd like to know more about possible uses of 
> such a feature.
> 
> 
> 
> 
> It may be useful to limit the size of the page cache for various reasons
> such as
> 
> 1. Insure that anonymous pages that may contain performance
>    critical data is never subject to swap.
> 
> 2. Insure rapid turnaround of pages in the cache.

So if these two aren't working properly at 100%, then I want to know the
reason why. Or at least see what the workload and the numbers look like.

> 
> 3. Reserve memory for other uses? (Aubrey?)

Maybe. This is still a bad hack, and I don't like to legitimise such use
though. I hope Aubrey isn't relying on this alone for his device to work
because his customers might end up hitting fragmentation problems sooner
or later.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
