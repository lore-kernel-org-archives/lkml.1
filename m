Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYH0Ob6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYH0Ob6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbYH0Obs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:31:48 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51940 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbYH0Obr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:31:47 -0400
Subject: Re: [PATCH 34/59] CRED: Wrap task credential accesses in the JFS
	filesystem
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, jfs-discussion@lists.sourceforge.net
In-Reply-To: <20080827134837.19980.65940.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	 <20080827134837.19980.65940.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 09:31:44 -0500
Message-Id: <1219847504.32515.1.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 14:48 +0100, David Howells wrote:
> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
> 
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
> 
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> Cc: jfs-discussion@lists.sourceforge.net
-- 
David Kleikamp
IBM Linux Technology Center

