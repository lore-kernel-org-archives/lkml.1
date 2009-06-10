Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbZFJTIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbZFJTIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZFJTIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:08:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43103 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZFJTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:08:39 -0400
Date: Wed, 10 Jun 2009 20:08:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31 -mm merge plans
Message-ID: <20090610190841.GT8633@ZenIV.linux.org.uk>
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 11:51:40AM -0700, Andrew Morton wrote:

> proc-merge-arrayc-into-basec.patch
> proc-merge-arrayc-into-basec-checkpatch-fixes.patch

I'm not sure that there's any point in that.  Sure, we can slap two
files together; what the hell for?  Both are quite large, there's
a (relatively) sane separation of code between them (misc. files
contents in /proc/<pid>/ vs. directory structure and symlinks in
there, more or less) and I don't see any benefit in mashing them
together.  Up to Alexey, but IMO that's pointless.
