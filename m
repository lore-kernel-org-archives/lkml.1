Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYKZINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYKZINt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYKZINj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:13:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbYKZINi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:13:38 -0500
Date: Wed, 26 Nov 2008 00:12:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print
 oops dumps
Message-Id: <20081126001234.19c9a7b0.akpm@linux-foundation.org>
In-Reply-To: <20081126072445.GG26036@elte.hu>
References: <20081123130042.1d194768@infradead.org>
	<20081126072445.GG26036@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 08:24:45 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> >  scripts/markup_oops.pl |  162 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 162 insertions(+), 0 deletions(-)
> >  create mode 100644 scripts/markup_oops.pl
> 
> looks useful - Andrew, Sam, any objections to this?

who-me-no-i-already-merged-it.

I didn't test it though - I don't have particularly high hopes given
the general deadness of `make mm/memory.lst' for the past numerous
years.

But it's worth trying.  The challenge will be getting people to
remember that it exists, and to use it.

I often turn off CONFIG_DEUG_INFO because it slows builds down so much.
It is irritating when such a kernel goes splat.

