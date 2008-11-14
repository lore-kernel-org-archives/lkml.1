Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYKNTqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYKNTqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYKNTqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:46:38 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:33742 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYKNTqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:46:38 -0500
Date: Fri, 14 Nov 2008 13:46:16 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Hugh Dickins <hugh@veritas.com>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_OPTIMIZE_INLINING fun
In-Reply-To: <Pine.LNX.4.64.0811141923030.10125@blonde.site>
Message-ID: <Pine.LNX.4.64.0811141343510.30981@quilx.com>
References: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
 <Pine.LNX.4.64.0811141244060.29394@quilx.com> <Pine.LNX.4.64.0811141923030.10125@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Hugh Dickins wrote:

> What I was intending anyway, quite independently of the INLINING
> issue, was changing those and some others to VM_BUG_ONs, which are
> intended really for VM testers rather than for distros to turn on.
> (Though perhaps Nick has shifted his position on that.)

Some distros have a bad habit of turning these on for production releases.

> That is indeed the orthodoxy.  I've never been so sold on it as most
> (there are cases when inlines give superior typechecking, but often
> the use of the macro will catch wrong types anyway).  But I suspect
> it's irrelevant, that changing those functions to macros would not
> actually have any effect on the problem - that's what we've often
> been assured, anyway, that the compiler nowadays does inlines as
> efficiently as the preprocessor does macros.  I do wonder though.

Maybe try to compare it with a old kernel that still has the page flags
macros? That way we would have a testcase useful for bringing to the
attention of the gcc people.

