Return-Path: <linux-kernel-owner+w=401wt.eu-S1762841AbXEPFv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762841AbXEPFv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761295AbXEPFvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:51:19 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:41992 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761166AbXEPFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:51:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=X7y9yoMdC+oHEF05aZLz1sIfzhNIFZjXfvuRnY+ZXAkrJnrAma1EnLor9NvZJTLwOZmnz1m+PPGKleiDrreEFalTiG+T43y3s/A1CIrh/pQaGJgR1/TnOylXigsZY/yqwyqkvaGYGT06dmseqUKON6hLjvRywvifT3IiGciIXp0=  ;
X-YMail-OSG: bjlv_ugVM1ko4fvmZ2hVvpNDheujzr5cJDyydvr_2qXo2SrBh1.fCpgEe7gNdIk1kWXLao1Bew--
Message-ID: <464A9BD1.1030300@yahoo.com.au>
Date: Wed, 16 May 2007 15:51:13 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nate Diller <nate.diller@gmail.com>
Subject: Re: Pagecache zeroing: zero_user_segment, zero_user_segments and
 zero_user
References: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com>	<20070515202442.eeaa49a0.akpm@linux-foundation.org>	<Pine.LNX.4.64.0705152100010.5091@schroedinger.engr.sgi.com>	<464A8DF5.2010903@yahoo.com.au> <20070515222912.ae836e00.akpm@linux-foundation.org>
In-Reply-To: <20070515222912.ae836e00.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 16 May 2007 14:52:05 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

>>>On the other hand non highmem platforms are burdened with always repeating
>>>the same KM_USER0 in every function call. Isnt it enough to know that 
>>>standard functions use KM_USER0 for their operations?
>>
>>Couldn't that be filtered out inline?
> 
> 
> It is - there is no runtime overhead for non-highmem machines.
> 
> The problem nowadays is all the developers who don't need, have, compile
> for or test on highmem machines.

Well sure, if that's all Christoph is worried about, then it isn't
really valid because in generic code we have to follow the architecture
abstraction API -- there is no "non highmem platform" in generic code :)

-- 
SUSE Labs, Novell Inc.
