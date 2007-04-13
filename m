Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXDMDKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXDMDKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 23:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXDMDKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 23:10:42 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:23732 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753164AbXDMDKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 23:10:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=1IlBwaM7/vPNSLN8VQ12R4zA13KJJrLYW26RNIzdqi7Tvjdb2YnFOlmVzpC49fL3sM8kUBzalW4nNPUPWZPi7UUSdvhW9sDjvNkt50NgSq8LJ32bilKgeMSFClBYHeRwqf546rPNkn6slKxwIwPn6TNfkb/7MXQ0Fvk6GV/5mDM=  ;
X-YMail-OSG: KbE2R4UVM1kC2cMPT2BBXFDW9K8k5NJNSrQJCHh1ynuJVZgHGDQ0Aeg3w2FAPxVtmzh_MIUD4Q--
Message-ID: <461EF4A5.4090604@yahoo.com.au>
Date: Fri, 13 Apr 2007 13:10:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com>	<20070412231050.GN2986@holomorphy.com>	<20070412163235.dd030637.akpm@linux-foundation.org>	<461ECB9C.8060000@yahoo.com.au>	<20070412174201.065068b2.akpm@linux-foundation.org>	<461ED96C.5030606@yahoo.com.au>	<20070412182213.a18cc4a7.akpm@linux-foundation.org>	<461EE005.6070605@yahoo.com.au>	<20070412185723.5a5f0443.akpm@linux-foundation.org>	<461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au>
In-Reply-To: <461EEFEC.2010205@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Andrew Morton wrote:

>>  Then you just end up with the same thing, don't you?
> 
> 
> Well _you_ do, because that happens to be exactly what you want. Bill
> ends up with something that displays page_mapcount instead. And I
> end up with something that traverses LRU lists rather than pfns. And
> none of it goes in /proc/ or linux-2.6/.

Oh, and you get to change it without recompiling and rebooting your
kernel.

-- 
SUSE Labs, Novell Inc.
