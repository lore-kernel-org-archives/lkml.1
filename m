Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYFWDvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYFWDvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYFWDv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:51:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:15735 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYFWDvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=owkTAdBralDQryY4xIK+F0qZuOcJ87Kq4nx9+Jcwx2ou+LMAYOqGvajmral2x7w1M+
         WleUu6+B86NpFWHLuMg+J2joVgm6aRZ5vBkdz6Qt6UvaJpDTzzdU1QoGBmL+forI7FFC
         o16yhWrl6clRT4SoyzHGQcB1e6ScWTqCl21fo=
Message-ID: <48f7fe350806222051g15edcd98g6faecc4a23f727ab@mail.gmail.com>
Date: Sun, 22 Jun 2008 23:51:25 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-mm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200806231229.42943.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
	 <1214147244.3223.307.camel@lappy.programming.kicks-ass.net>
	 <48f7fe350806220818n52cc36e9v28bdc6cf2c4cf841@mail.gmail.com>
	 <200806231229.42943.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

well i get the hardlock on -mm with out using reiser4, i am pretty
sure is swap related

On Sun, Jun 22, 2008 at 10:29 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Monday 23 June 2008 01:18, Ryan Hope wrote:
>> Well in the current version of the patchset we are using, one user
>> would start playing some game (disabling "Disable Heap Randomization"
>> fixed the hardlocks for him... the other user got hardlocks when
>> copying an ISO from a reiser4 partition to a reiserfs partition
>> (disabling swap fixed the issue for him).
>
> Hmm, nobody has reported such a hang with -mm yet, so maybe it
> is another interaction in the patchset. OTOH, probably nobody
> much uses -mm and reiser4, and reiser4 does lots of weird fiddling
> with pagecache so it could be broken in -mm even.
>
>
