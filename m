Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYHRIMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYHRIMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYHRIMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:12:32 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:42389 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751514AbYHRIMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:12:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mXYf6haPawvqzVSWWb+O2w+sy5EWlkQFGE58z9UTYUR9ZSv3poXfd6bFfwqqwPY7tWfRd5XKXSBmmwcq1UyTcwHotsVj1O2EiGgMXz7ddzWYzWbmVQC/G0pEKTiMYaZ/Syj1Ul5SyDL3ZzucyeQSWUOCJgtrgY9YMVhS7AHjwIg=  ;
X-YMail-OSG: NVecZAsVM1n2Jt9TyqPjOY68b1bYZgHDLEGxfEqwcVOb5HXdY_npP9rUlpu5Gk0fmrgco5lACSDWOuush.ZrG.cjrcM6cOWtFS4Qu13tzIP1yXkESDecCMgABGcwscwjtm0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] mm: dirty page tracking race fix
Date: Mon, 18 Aug 2008 18:12:17 +1000
User-Agent: KMail/1.9.5
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080818053821.GA3011@wotan.suse.de> <200808181803.57730.nickpiggin@yahoo.com.au> <1219046833.10800.270.camel@twins>
In-Reply-To: <1219046833.10800.270.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181812.17595.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 18:07, Peter Zijlstra wrote:
> On Mon, 2008-08-18 at 18:03 +1000, Nick Piggin wrote:
> > On Monday 18 August 2008 17:49, Peter Zijlstra wrote:
> > > On Mon, 2008-08-18 at 07:38 +0200, Nick Piggin wrote:
> > > > It's possible to retain this optimization for page_referenced and
> > > > try_to_unmap.
> > >
> > > s/synch/sync/ ?
> > >
> > > we use sync all over the kernel to mean synchonous, so why are you
> > > inventing a new shorthand?
> >
> > Mmm, we also use synch all over the kernel to mean synchronous,
> > including in mm/, so I'm not inventing a new shorthand. sync I
> > see is more common, but it's not something anybody would get
> > confused about is it?
>
> I hadn't noticed before, and my grep skillz seem to have left me in the
> cold
>
> git grep "\<synch\>" mm/* | wc -l
> 0

"asynch" ;) 1 hit! So *technically* I'm wrong...


> And you're right, its not something one can get confused about. So lets
> just keep it unless someone else objects ;-)

Andrew feel free to edit the patch if/when you pick it up :P
