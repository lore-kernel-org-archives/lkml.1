Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYH0WTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYH0WTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYH0WT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:19:26 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:37335 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbYH0WTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:19:25 -0400
Date: Wed, 27 Aug 2008 18:19:24 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 03/59] CRED: Wrap task credential accesses in the
	PA-RISC arch
Message-ID: <20080827221924.GA6298@phobos.i.cabal.ca>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk> <20080827134557.19980.40787.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827134557.19980.40787.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:45:57PM +0100, David Howells wrote:
> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
> 
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
> 
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
> 

OK.

Feel free to push this with the rest of them, if you haven't already,
with my blessing.

r, Kyle
