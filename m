Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbYLCNlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbYLCNlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYLCNlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:41:12 -0500
Received: from cmpxchg.org ([85.214.51.133]:41369 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYLCNlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:41:12 -0500
Date: Wed, 3 Dec 2008 14:40:35 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: drop const qualifier for kernel_execve()
Message-ID: <20081203134035.GA17560@cmpxchg.org>
References: <2375c9f90812021451hfd77292yf2463ca99d07b88e@mail.gmail.com> <20081203012051.GA8953@cmpxchg.org> <2375c9f90812030432m771984edkdd0c599bbae9bb3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90812030432m771984edkdd0c599bbae9bb3c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 12:32:02PM +0000, Américo Wang wrote:
> On Wed, Dec 3, 2008 at 1:20 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Tue, Dec 02, 2008 at 10:51:09PM +0000, Américo Wang wrote:
> >> UML implementation of kernel_execve() should not have const qualifier,
> >> because it will finally call do_execve() which doesn't have.
> >
> > And you made sure that do_execve() is correctly annotated?
> >
> 
> Yes, I checked that.

Good.  Then please fix up do_execve() or let the warning stand out as
a reminder.

	Hannes
