Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYFTNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYFTNBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYFTNBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:01:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYFTNBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:01:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] autofs4 - detect invalid direct mount requests
References: <20080620051301.9988.94307.stgit@raven.themaw.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 20 Jun 2008 09:00:20 -0400
In-Reply-To: <20080620051301.9988.94307.stgit@raven.themaw.net> (Ian Kent's
	message of "Fri, 20 Jun 2008 13:13:03 +0800")
Message-ID: <x49iqw4tg63.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> autofs v5 dierct and offset mounts within an autofs filesystem are
> triggered by existing autofs triger mounts so the mount point dentry
> must be positive. If the mount point dentry is negative then the
> trigger doesn't exist so we can return fail immediately.

What are the conditions that lead us here in that case?

-Jeff
