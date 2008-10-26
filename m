Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYJZPUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYJZPUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 11:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYJZPUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 11:20:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:4870 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbYJZPUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 11:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QLvR97HV3la1UoO/5PvE7mgTqOHo6d1xlUzsXjbplnfXm8CJrAS6UlryQXVWFjqdeh
         h5UEPy0wItcVMieg0pXtcyM9Vy+BjFVBFElNxy6WJFPx3bbIEXgFwpXk0wvKcJM+EraI
         ANeC6Cn6DDwX0YihxdMw6QjNKo6BJK4cKeU4A=
Message-ID: <c384c5ea0810260820ye9ebd70y587c013c7bef2579@mail.gmail.com>
Date: Sun, 26 Oct 2008 16:20:14 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] Rename DECLARE_MUTEX to DEFINE_SEMAPHORE
Cc: "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matthew Wilcox" <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225032063.32713.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081026120609.GA10728@joi> <1225028346.32713.11.camel@twins>
	 <c384c5ea0810260711l1103a103j6c3739fe3a8d9e74@mail.gmail.com>
	 <1225032063.32713.17.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Oct 26, 2008 at 3:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2008-10-26 at 15:11 +0100, Leon Woestenberg wrote:
>> On Sun, Oct 26, 2008 at 2:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Sun, 2008-10-26 at 13:06 +0100, Marcin Slusarz wrote:
>> >> DECLARE_MUTEX is doubly misleading name (it actually _defines_ struct
>> >> _semaphore_ initialized to 1) and it can be confused with DEFINE_MUTEX
>> >> (which defines real struct mutex). Rename it.
>> >
>> > I'd prefer DEFINE_BINARY_SEM or somesuch
>> >
>> But it is not a binary semaphore, or is it?
>
>> #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
>
> I thought that 1 made it a binary sem.
>
I thought it only initialized the semaphore count to 1, but not
disallowing it to be upped.  Maybe am I just plain wrong, and I should
be zapped to kernelnewbies instead. :-/

Regards,
-- 
Leon
