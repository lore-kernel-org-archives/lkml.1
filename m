Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYEKV7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYEKV7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYEKV7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:59:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:31024 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYEKV7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H8DLnDk+VMPK1aCtWH1l6JeZbsAE3uH1Duj+E9XO269FYiJQGnmYGSkGEwUpYZvtAIl6xshtrsm4y3daSpXM3acCgKprULy9FiS4GJCuAratMlWVFhEnf8PoLuyeYuuTsAAMdYDhY0gE2VSRlB1hE2adc9CYD2lM8La+KrxMtdo=
Message-ID: <82e4877d0805111459jf4891fbpff5a91b08e32db01@mail.gmail.com>
Date: Sun, 11 May 2008 17:59:21 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [Bug #10616] Horrendous Audio Stutter - current git
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Frans Pop" <elendil@planet.nl>
In-Reply-To: <20080511214131.GM1645@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
	 <88YBFoyd1CN.A.K6.1w1JIB@chimera>
	 <82e4877d0805111428j3f73f436w1c6094c779f6110d@mail.gmail.com>
	 <20080511214131.GM1645@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 5:41 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Sun, May 11, 2008 at 05:28:47PM -0400, Parag Warudkar wrote:
>> On Sun, May 11, 2008 at 4:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.25.  Please verify if it still should be listed.
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10616
>> > Subject         : Horrendous Audio Stutter - current git
>>
>> Still present both in Linus tree and sched-devel - root cause is not
>> yet well understood per Ingo.
>>
>> Worked around by disabling GROUP_SCHED stuff by default (commit
>> aac6abca858386438d9a7233c3471d2ecfa2f704 ).
>
> What causes this regression?

GROUP_SCHED stuff.

>
> Is this commit 018d6db4cb5bbdcd65424a16f2dcca692ed32ae4
> (sched: re-do "sched: fix fair sleepers") that had already been reverted
> in 2.6.25 for causing such regressions or is this caused by a different
> commit?

Both current -git and sched-devel have this problem - that means it's
unrelated to the commit you refer to unless it was reintroduced in a
different form but same effect.

Parag
