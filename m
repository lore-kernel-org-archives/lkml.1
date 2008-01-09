Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYAIKES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYAIKES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYAIKEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:04:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42206 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYAIKEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:04:07 -0500
Date: Wed, 9 Jan 2008 10:03:44 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hch@infradead.org,
       pagg@oss.sgi.com, erikj@sgi.com, pj@sgi.com, matthltc@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] add task handling notifier
Message-ID: <20080109100344.GA7342@infradead.org>
References: <476A780C.76E4.0078.0@novell.com> <20071223122621.GA19310@infradead.org> <20071225140526.547a882f.akpm@linux-foundation.org> <47838ACB.76E4.0078.0@novell.com> <20080108141424.de5d8fba.akpm@linux-foundation.org> <4784A751.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4784A751.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 09:52:01AM +0000, Jan Beulich wrote:
> Yes. And the unidentified feature is NLKD. But as with other notifiers (most
> notably the module unload one), all reasonable kernel debuggers should
> need them (or do explicit patching of the mentioned source files). As I
> explained before, I think that if kernel debuggers aren't allowed into the
> tree, they should at least be allowed to co-exist (since the argument of
> requiring in-tree users and submitting code for mainline inclusion is void
> if political/personal reasons exclude certain code from even being
> considered for inclusion).

We already have a kernel debugger in tree, xmon.  There's anotherone
hopefully getting in soon (kgdb), so they can do the right thing as the
other subsystems.

And as usual, we're not going to provide hooks for out of tree mess.

