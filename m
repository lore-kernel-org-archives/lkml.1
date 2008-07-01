Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYGAILM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYGAILM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbYGAIKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:10:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701AbYGAIKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:10:49 -0400
Date: Tue, 1 Jul 2008 01:10:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (resend) reuse xxx_fifo_fops for xxx_pipe_fops
Message-Id: <20080701011045.f4490332.akpm@linux-foundation.org>
In-Reply-To: <200807011203.50632.vda.linux@googlemail.com>
References: <200807011103.02974.vda.linux@googlemail.com>
	<20080701003255.493f54e0.akpm@linux-foundation.org>
	<200807011203.50632.vda.linux@googlemail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 12:03:50 +0200 Denys Vlasenko <vda.linux@googlemail.com> wrote:

> I think since XXX_pipe_fops are only used in this file,
> just explaining this in the comment would be enough.

no, a comment is only needed when the code is unobvious.  Make
the code obvious and we don't need a comment.

As Christoph pointed out, open-coding shared_read_fops everywhere
might make sense too.  It'd make it harder to unshare them later
on, but that's pretty improbable.
