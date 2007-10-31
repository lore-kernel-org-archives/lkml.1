Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbXJaE6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbXJaE6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXJaE6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:58:37 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:25087 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751487AbXJaE6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:58:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O7Ugo8TTSnXWJHk64FKA92lzmSAQQKcG8ad/ILtyFyjEAC0xsusgwGbHrgOJj8RzGdJzGETyo4/FL0C3QbOtODlYZ6cove4nY4W95PogJSZXvJS2TRa+f6u2JuKmdpEvCn0mqJvlNcal60iKgFnMWFyVs5oOQ8I9K70/+j8rPvs=  ;
X-YMail-OSG: NpmcQEUVM1nzXs0DdnQ1TmGR20rHx22t5ZPK2ao.MWaxwZREJI8bc1Y7vgr06il_P_xoFMlfqw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/33] mm: allow PF_MEMALLOC from softirq context
Date: Wed, 31 Oct 2007 14:51:56 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl> <20071030160911.540148000@chello.nl>
In-Reply-To: <20071030160911.540148000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311451.56747.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> Allow PF_MEMALLOC to be set in softirq context. When running softirqs from
> a borrowed context save current->flags, ksoftirqd will have its own
> task_struct.


What's this for? Why would ksoftirqd pick up PF_MEMALLOC? (I guess
that some networking thing must be picking it up in a subsequent patch,
but I'm too lazy to look!)... Again, can you have more of a rationale in
your patch headers, or ref the patch that uses it... thanks

