Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbYH2Wda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbYH2Wda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYH2WdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:33:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbYH2WdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:33:07 -0400
Date: Fri, 29 Aug 2008 19:32:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       video4linux-list@redhat.com
Subject: Re: [PATCH 11/59] CRED: Wrap task credential accesses in video
 input drivers
Message-ID: <20080829193227.1494de9b@mchehab.chehab.org>
In-Reply-To: <20080827134638.19980.39537.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	<20080827134638.19980.39537.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008 14:46:39 +0100
David Howells <dhowells@redhat.com> wrote:

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
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>

I'll add it on my tree and keep it for linux-next.

Cheers,
Mauro
