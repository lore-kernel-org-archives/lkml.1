Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYK1Kqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYK1Kqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYK1Kqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:46:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47807 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYK1Kq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:46:29 -0500
Date: Fri, 28 Nov 2008 10:45:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v10][PATCH 02/13] Checkpoint/restart: initial
	documentation
Message-ID: <20081128104554.GP28946@ZenIV.linux.org.uk>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu> <1227747884-14150-3-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227747884-14150-3-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 08:04:33PM -0500, Oren Laadan wrote:

> +Currently, namespaces are not saved or restored. They will be treated
> +as a class of a shared object. In particular, it is assumed that the
> +task's file system namespace is the "root" for the entire container.
> +It is also assumed that the same file system view is available for the
> +restart task(s). Otherwise, a file system snapshot is required.

That is to say, bindings are not handled at all.

> +* What additional work needs to be done to it?

> +We know this design can work.  We have two commercial products and a
> +horde of academic projects doing it today using this basic design.

May I use that for a t-shirt, please?  With that quote in foreground, and
pus-yellow-greenish "MACH" serving as background.  With the names of products
and projects dripping from it...
