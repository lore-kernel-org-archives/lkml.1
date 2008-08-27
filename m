Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYH0XEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYH0XEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYH0XEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:04:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYH0XEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:04:12 -0400
Date: Wed, 27 Aug 2008 16:04:10 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Joel Becker <joel.becker@oracle.com>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 38/59] CRED: Wrap task credential accesses in the OCFS2 filesystem
Message-ID: <20080827230410.GP4563@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk> <20080827134858.19980.65277.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827134858.19980.65277.stgit@warthog.procyon.org.uk>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:48:58PM +0100, David Howells wrote:
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
Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
