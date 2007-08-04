Return-Path: <linux-kernel-owner+w=401wt.eu-S933272AbXHDTha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbXHDTha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765567AbXHDThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:37:09 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:54932
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbXHDThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:37:07 -0400
Date: Sat, 4 Aug 2007 12:34:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rob Landley <rob@landley.net>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/2] Group architecture Documentation under Documentation/arch.
In-Reply-To: <200708041419.55454.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0708041232060.6905@asgard.lang.hm>
References: <200705222225.39949.rob@landley.net> <Pine.LNX.4.64.0705230922580.19474@anakin>
 <200708041404.01264.rob@landley.net> <200708041419.55454.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007, Rob Landley wrote:

> On Saturday 04 August 2007 2:03:59 pm Rob Landley wrote:
>> Signed-off-by: Rob Landley <rob@landley.net>
>> Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>
>> Move architecture-specific Documentation into a common subdirectory.
>
> I really, really, really hate git.
>
> Ok, on my laptop I just noticed that "git apply" of the patch didn't complain
> but it also left the empty subdirectories it moved stuff out of.  (I don't
> believe this happened on the version of git I was using on my previous
> laptop, which ate itself a month and change ago, but obviously I can't
> check.)
>
> There is no "git rmdir".  "git rm" refuses to delete the directory
> without -r.  "git rm -r Documentation/x86_64" listed (as just deleted) all
> the files that the patch already moved out of the directory.
>
> Am I missing something obvious here?

no, git doesn't track directories, it tracks files in directories. there 
was just an extensive discussion on the git mailing list about this.

I beleive that doing a checkout will clear out those directories, or you 
can just rm -r them. after you empty them out.

David Lang
