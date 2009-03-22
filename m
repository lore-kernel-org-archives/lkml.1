Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZCVUku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZCVUku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZCVUkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:40:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:45433 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZCVUkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903221833140.17976@blonde.anvils>
References: <Pine.LNX.4.64.0903221833140.17976@blonde.anvils>
Date: Sun, 22 Mar 2009 13:40:38 -0700
Message-ID: <aca0ce8b0903221340s461b4025m752b5ef038224163@mail.gmail.com>
Subject: Re: [PATCH mmotm] mm: page_mkwrite change prototype to match fault: 
	fix sysfs
From: Eric Biederman <ebiederm@aristanetworks.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 11:36 AM, Hugh Dickins <hugh@veritas.com> wrote:
> Fix warnings and return values in sysfs bin_page_mkwrite(), fixing
> fs/sysfs/bin.c: In function `bin_page_mkwrite':
> fs/sysfs/bin.c:250: warning: passing argument 2 of `bb->vm_ops->page_mkwrite' from incompatible pointer type
> fs/sysfs/bin.c: At top level:
> fs/sysfs/bin.c:280: warning: initialization from incompatible pointer type

In general this looks reasonable.  It appears that linux-next has
changed the prototype
of page_mkwrite.    Which is why I did not see this failure mode.
