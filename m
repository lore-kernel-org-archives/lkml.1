Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbZFJTQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbZFJTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbZFJTQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:16:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbZFJTQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:16:49 -0400
Date: Wed, 10 Jun 2009 12:16:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, WANG Cong <amwang@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.31 -mm merge plans
Message-Id: <20090610121633.d678fc8b.akpm@linux-foundation.org>
In-Reply-To: <20090610190841.GT8633@ZenIV.linux.org.uk>
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
	<20090610190841.GT8633@ZenIV.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Wed, 10 Jun 2009 20:08:41 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Jun 10, 2009 at 11:51:40AM -0700, Andrew Morton wrote:
> 
> > proc-merge-arrayc-into-basec.patch
> > proc-merge-arrayc-into-basec-checkpatch-fixes.patch
> 
> I'm not sure that there's any point in that.  Sure, we can slap two
> files together; what the hell for?  Both are quite large, there's
> a (relatively) sane separation of code between them (misc. files
> contents in /proc/<pid>/ vs. directory structure and symlinks in
> there, more or less) and I don't see any benefit in mashing them
> together.  Up to Alexey, but IMO that's pointless.

No strong opinions here.

AFAIK Alexey isn't doing procfs any more?
