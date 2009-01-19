Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZASTGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZASTGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZASTGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:06:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52916 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZASTGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:06:02 -0500
Date: Mon, 19 Jan 2009 20:03:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaliy Gusev <vgusev@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] kthread: Don't looking for a task in create_kthread()
Message-ID: <20090119190331.GA24852@redhat.com>
References: <200901192028.34594.vgusev@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901192028.34594.vgusev@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Vitaliy Gusev wrote:
>
> Let a process fill result, as 'current' is the same
> in all pid namespaces.

This looks like a very nice patch to me.

But I don't understand the changelog. Afaics, this has nothing to do
with namespaces. We can remove the unnecessary find_task_by_pid_ns()
kthread() can just use "current" to get the same result.

Could you please improve the changelog and re-send?

Oleg.

