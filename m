Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbXEPEwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbXEPEwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 00:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXEPEwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 00:52:18 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:37465 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752151AbXEPEwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 00:52:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=AwJ39IKVqkMTOF8+iq+gwr6Y4l3mz15SkVC09NFKtNnN+WvciafcmQ81+KZr8k62fj0HbI2qK79CTYnuSm2SE/DfdHK5nzZkz5Ls9/vo3rVSyktSxmP8dAc2AByfwSkagKN4fwjuZFF4Flqt2uJcGrxsBOKRSlhYc+fvRgh8Mgc=  ;
X-YMail-OSG: 4X9pgc8VM1n1qwxgitNNGNWFuA.kTestpFENfYC8yEKkEJpKkOCc2_zbjKnYVWGuen01xXwhCQ--
Message-ID: <464A8DF5.2010903@yahoo.com.au>
Date: Wed, 16 May 2007 14:52:05 +1000
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
References: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com> <20070515202442.eeaa49a0.akpm@linux-foundation.org> <Pine.LNX.4.64.0705152100010.5091@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705152100010.5091@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 15 May 2007, Andrew Morton wrote:
> 
> 
>>>   The functions above default to KM_USER0 which is also always used when
>>>   zero_user_page was called except in one single case. We open code that
>>>   single case to draw attention to the spot.
>>>
>>
>>Dunno.  fwiw, we decided to _not_ embed KM_USER0 in the callee: we have had
>>some pretty ghastly bugs in the past due to misuse of kmap slots so the
>>idea was to shove the decision into the caller's face, make them think
>>about what they're doing
> 
> 
> On the other hand non highmem platforms are burdened with always repeating
> the same KM_USER0 in every function call. Isnt it enough to know that 
> standard functions use KM_USER0 for their operations?

Couldn't that be filtered out inline?

-- 
SUSE Labs, Novell Inc.
