Return-Path: <linux-kernel-owner+w=401wt.eu-S2992691AbXCGWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992691AbXCGWlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992688AbXCGWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:41:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35351 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992694AbXCGWlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:41:12 -0500
Date: Wed, 7 Mar 2007 14:41:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Petr =?ISO-8859-1?Q?Tesa=5F=5F=EDk?= <ptesarik@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] remove_arg_zero() rewrite
Message-Id: <20070307144101.f97cfa53.akpm@linux-foundation.org>
In-Reply-To: <1173305397.4868.4.camel@lappy>
References: <1171978145.22720.21.camel@golias.tesarici.cz>
	<20070221154159.d316d526.akpm@linux-foundation.org>
	<1173305397.4868.4.camel@lappy>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 23:09:57 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2007-02-21 at 15:41 -0800, Andrew Morton wrote:
> 
> > I mean.... what the hell?
> > 
> > As you appear to have managed to work out what the sorry thing is trying to
> > do, would you have time to simply rip it out and completely rewrite it,
> > including a nice comment telling the world what this function's function is?
> > 
> > Because what we have there is beyond repairing.
> 
> Something like so?
> Boots uml seemingly without errors.
> 
> ---
> Rewrite remove_arg_zero() to be more parseable by untwisted minds.
> 

Sorry, Nick already had a go at this:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm2/broken-out/exec-fix-remove_arg_zero.patch

But your patch has a nice comment and has to be better ;)

