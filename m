Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbYJFATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbYJFATS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 20:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYJFATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 20:19:04 -0400
Received: from mail.lang.hm ([64.81.33.126]:59593 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYJFATD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 20:19:03 -0400
Date: Sun, 5 Oct 2008 17:19:28 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mikulas Patocka <mpatocka@redhat.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: application syncing options (was Re: [PATCH] Memory management
 livelock)
In-Reply-To: <Pine.LNX.4.64.0810052002520.5798@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.DEB.1.10.0810051714330.17288@asgard.lang.hm>
References: <20080911101616.GA24064@agk.fab.redhat.com> <20080923154905.50d4b0fa.akpm@linux-foundation.org> <200810031232.23836.nickpiggin@yahoo.com.au> <200810031254.29121.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0810030845070.14680@asgard.lang.hm>
 <Pine.LNX.4.64.0810052002520.5798@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Mikulas Patocka wrote:

> On Fri, 3 Oct 2008, david@lang.hm wrote:
>
>> I've also seen discussions of how the
>> kernel filesystem code can do ordered writes without having to wait for them
>> with the use of barriers, is this capability exported to userspace? if so,
>> could you point me at documentation for it?
>
> It isn't. And it is good that it isn't --- the more complicated API, the
> more maintenance work.

I can understand that most software would not want to deal with 
complications like this, but for things thta have requirements similar to 
journaling filesystems (databases for example) it would seem that there 
would be advantages to exposing this capabilities.

David Lang
