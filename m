Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYACGHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYACGHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 01:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbYACGHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 01:07:32 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:48834 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752344AbYACGHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 01:07:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BjOIs3BnWUhcKsxG8VUEUaz+EBWgZSd1iXZHHvpbjgCYHHpR7FKq44w5H4I5UWj6v7Bkg9vwy7rUJH3BSO5ianDVPSJ0xMfHPUWX7ZGcFC+7Gyr7AFG8hcN49XTOs0uU9mfDWtmCuFsAcsZDin4KQkfcAeRA6CvQI/gLM0G/VqQ=  ;
X-YMail-OSG: 7SiYuqEVM1lNTUtT0s3ZQpZXzAeQu654YfHSXVfcw.Kb8EVI_UoGKYL5mndpZs02rCgM.PViTw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
Date: Thu, 3 Jan 2008 17:07:14 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20071218211539.250334036@redhat.com> <200712201859.12934.nickpiggin@yahoo.com.au> <477C1FB6.5050905@sgi.com>
In-Reply-To: <477C1FB6.5050905@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031707.14607.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 10:35, Mike Travis wrote:
> Hi Nick,
>
> Have you done anything more with allowing > 256 CPUS in this spinlock
> patch?  We've been testing with 1k cpus and to verify with -mm kernel,
> we need to "unpatch" these spinlock changes.
>
> Thanks,
> Mike

Hi Mike,

Actually I had it in my mind that 64 bit used single-byte locking like
i386, so I didn't think I'd caused a regression there.

I'll take a look at fixing that up now.

Thanks,
Nick
