Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbZLWTrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbZLWTrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZLWTrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:47:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56523 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZLWTrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:47:15 -0500
Date: Wed, 23 Dec 2009 20:47:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [PATCH 0/7] utrace/ptrace
Message-ID: <20091223194712.GO20539@basil.fritz.box>
References: <20091218011116.GA29534@redhat.com> <20091222135809.1ab10869.akpm@linux-foundation.org> <20091223174232.GA14993@redhat.com> <20091223193313.1B89E16DB@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223193313.1B89E16DB@magilla.sf.frob.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As Oleg mentioned, I have a cleanup/reimplementation of seccomp using
> utrace.  That is quite a trivial use--it demonstrates how easy the
> utrace API makes it to do things like that, in contrast to previous
> solutions with arch-specific assembly hacking and so forth.  I can
> dust that patch off and post it if anybody cares.

Do you have an estimate or better numbers how the overhead of 
seccomp-over-utrace compares to the current in-tree seccomp?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
