Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXDMC3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXDMC3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXDMC3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:29:40 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:37196 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752969AbXDMC3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:29:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Q9wgyrHL5iEMaj0eQnQMqCQu+2t6OKXsVUdu4G6LNXZRGTWow7aH03h5byiVq4oEibHXRGHN5oexMZUxkSeU7LmZGKqUWkSHpyysa3bD+NscImscsNYb2FtIRK3edzo6DJAEtSiZ4f4B9o6gWHlTmThH2DUsnIfdaZh5VUWUcAY=  ;
X-YMail-OSG: VZTqslAVM1kF.bHG30y_l1ogKuL.z9jYRA_2s5LvJCa29W0L10j2o8sk3bwOsYOw3WYn3jfJ4A--
Message-ID: <461EEB0B.2050906@yahoo.com.au>
Date: Fri, 13 Apr 2007 12:29:31 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <20070413020530.GM11115@waste.org>
In-Reply-To: <20070413020530.GM11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Thu, Apr 12, 2007 at 06:57:23PM -0700, Andrew Morton wrote:
> 
>>I guess one could generate an answer to the static question with systemtap,
>>by accumulating running counts across the application lifetime and then
>>snapshotting them.  Sounds hard though.
> 
> 
> You'd have to do it from boot onward to get a complete system image.
> One way to look at it is that systemtap can give you the derivative of
> the information, and you have to integrate it.

So everyone keeps saying.

Would you tell me why you can't just traverse the data structures
in the same way as your proc handler? From the systemtap example
scripts it seems like you can traverse arbitrary kernel data
structures.

-- 
SUSE Labs, Novell Inc.
