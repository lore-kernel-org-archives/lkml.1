Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYIBICx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYIBICx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 04:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYIBICh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 04:02:37 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:47138 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbYIBICd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iMfkwUzwUUP2+Xz1CVikq/HhG6NLdd+qlR9M+zdl3dti94o1i3s+FVg7SYGK112xRE
         F3otMgomwWjjD4ursNbi/m32nlngUIwXFNwbMw+N0/2WwwGQCjg4V/WU2UOyfq+Exnip
         j3Jhz7RF08dG5k5N5LSDq54ppDzzVtwvEmgeM=
Message-ID: <91b13c310809020102j42e91ba2q65dd2f2f60bfde35@mail.gmail.com>
Date: Tue, 2 Sep 2008 16:02:30 +0800
From: "rae l" <crquan@gmail.com>
To: "Dan Williams" <dan.j.williams@intel.com>, jmm@users.sourceforge.net,
       mhydra@users.sourceforge.net, miku@users.sourceforge.net
Subject: Re: from raid456 patch, about the tiotest tool
Cc: linux-raid@vger.kernel.org,
       "James W. Laferriere" <babydr@baby-dragons.com>,
       "Neil Brown" <neilb@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <91b13c310808261103y326d57e8q737647b88d925daa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310808261103y326d57e8q737647b88d925daa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 2:03 AM, rae l <crquan@gmail.com> wrote:
> Hello, Dan:
>  I've known your md(raid456) patch just before v2.6.26,
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8b3e6cdc53b7f29f7026955d6cb6902a49322a15
>
> your md patch referred to tiobench, which is the multi-thread
> benchmark tool, I'm interested on this tool and I found I ran it
> differently with your results, so I want to know more about it,
>
> from its home page, it only released v0.3.3 on Mar 2002,
>
> http://sourceforge.net/projects/tiobench/
>
> but from its cvs repository, it has released v0.4.1,
>
> http://tiobench.cvs.sourceforge.net/tiobench/tiobench/
>
> Could you tell me what version of tiobench did you use? I want to see
> if that's my configuration fault or I have used wrong program version.
>
> And when using v0.4.1 of tiobench from its cvs repository, I found its
> multiple threads random IO statistics code reported wrong results, and
> have resolved it by this patch,
>
> http://sourceforge.net/tracker/index.php?func=detail&aid=2047536&group_id=3857&atid=303857
>
> But its upstream seems have not noticed it yet, so I want to if
> someone on this mailling-list know tiobench upstream and be able to
> take this message?

Hope someone can wake up the tiobench developer?


>
> Thanks.
>
> --
> Denis Cheng
>
