Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbXEPGUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbXEPGUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbXEPGT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:19:56 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:40889 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756300AbXEPGTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:19:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Klx6VsJkh/KFpNWj8OyL9ssINpCrFek6CHEPTLEjRgPNgfCiYjSXrMCQlDUsJzRWppH9BwlAAJEXExAwFtzoX9KRj5kSO56tWewHaVw2eA3HG5bSg+VTqBveYbGX/Z12PiztfknqaivgQa1DIoC3JkOHZ8ucDfIzrR/na2xXjW8=  ;
X-YMail-OSG: WlcZ4sAVM1k1Jt5yr_1ysmNNwPHejsmdsa5d.RVJ0K6Z5wzibZmKOLwGs6myAGE7JYY3NyoHmw--
Message-ID: <464AA285.4010309@yahoo.com.au>
Date: Wed, 16 May 2007 16:19:49 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nate Diller <nate.diller@gmail.com>
Subject: Re: Pagecache zeroing: zero_user_segment, zero_user_segments and
 zero_user
References: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com> <20070515202442.eeaa49a0.akpm@linux-foundation.org> <Pine.LNX.4.64.0705152100010.5091@schroedinger.engr.sgi.com> <464A8DF5.2010903@yahoo.com.au> <20070515222912.ae836e00.akpm@linux-foundation.org> <464A9BD1.1030300@yahoo.com.au> <Pine.LNX.4.64.0705152309180.5772@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705152309180.5772@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 16 May 2007, Nick Piggin wrote:
> 
> 
>>Well sure, if that's all Christoph is worried about, then it isn't
>>really valid because in generic code we have to follow the architecture
>>abstraction API -- there is no "non highmem platform" in generic code :)
> 
> 
> But there is a default KM_USER0 that is used in many functions.
> 
> F.e.
> 
> filemap_copy_from_user *_iovec xip_truncate_page clear_user_highpage 
> clear_highpage copy_user_highpage copy_highpage
> 
> So explicitly mentioning KM_USER0 in every function call is not a 
> requirement.

You probably have an argument there... but that's not to do with
highmem platforms or not.

-- 
SUSE Labs, Novell Inc.
