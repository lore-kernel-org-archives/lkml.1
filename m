Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbYEUMJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbYEUMJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760920AbYEUMJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:09:33 -0400
Received: from ozlabs.org ([203.10.76.45]:40916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760140AbYEUMJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:09:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce down_nowait()
Date: Wed, 21 May 2008 22:09:16 +1000
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Matthew Wilcox <matthew@wil.cx>
References: <200805211600.16415.rusty@rustcorp.com.au> <20080521080452.GA1305@infradead.org> <20080521011926.18bf8e81.akpm@linux-foundation.org>
In-Reply-To: <20080521011926.18bf8e81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805212209.17442.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008 18:19:26 Andrew Morton wrote:
> The number of down_trylocks in rc3 is 51 and the number of
> down_trylocks and down_nowaits in -mm is 47.  So progress is pretty
> glacial.
...
> Anyway, yes, I agree that the whole effort is a bit dubious and that
> the time could be better directed to semaphore eliminations.

It is deeply annoying, even embarrassing, and trivial to fix.  And as you say, 
process is glacial...

Cheers,
Rusty.
