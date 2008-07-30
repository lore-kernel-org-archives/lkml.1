Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYG3Rvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYG3Rvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYG3Rvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:51:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbYG3Rvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:51:39 -0400
Date: Wed, 30 Jul 2008 10:50:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Message-Id: <20080730105052.f05865d4.akpm@linux-foundation.org>
In-Reply-To: <20080730173944.GC28604@cs181140183.pp.htv.fi>
References: <200807301438.55941.rusty@rustcorp.com.au>
	<20080730033523.0f38f7e4.akpm@linux-foundation.org>
	<20080730154736.GC21597@cs181140183.pp.htv.fi>
	<20080730100355.f1402dcf.akpm@linux-foundation.org>
	<20080730170939.GA28604@cs181140183.pp.htv.fi>
	<20080730101438.e1484440.akpm@linux-foundation.org>
	<20080730171845.GB28604@cs181140183.pp.htv.fi>
	<20080730102817.c74a9e33.akpm@linux-foundation.org>
	<20080730173944.GC28604@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 20:39:44 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> > On non-CONFIG_HAVE_GET_USER_PAGES_FAST architectures a
> > get_user_pages_fast() call will in fact call get_user_pages().
> > 
> > On CONFIG_HAVE_GET_USER_PAGES_FAST architectures, get_user_pages_fast()
> > is a real function.  All architectures which implement that function
> > should export it to modules.  Hence it should be exported from within
> > generic code.
> 
> Are we talking at cross purposes?

Apparently.

> I thought you were talking an error due to a missing function.

Nope.

> If you think about an error where the function is present but only the 
> EXPORT_SYMBOL is missing

yup.

> then I get your point (although I do not 
> consider it a huge problem).

Me either.
