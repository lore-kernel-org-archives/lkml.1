Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYH0XuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYH0XuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYH0XuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:50:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:43335 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbYH0XuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:50:08 -0400
Subject: Re: [PATCH 04/59] CRED: Wrap task credential accesses in the
	PowerPC arch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20080827134602.19980.59222.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	 <20080827134602.19980.59222.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 09:45:33 +1000
Message-Id: <1219880733.13162.220.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 14:46 +0100, David Howells wrote:
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
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: linuxppc-dev@ozlabs.org
> ---

Ack.

Ben.


