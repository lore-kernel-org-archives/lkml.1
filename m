Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZIPAkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZIPAkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIPAkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:40:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18480 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZIPAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:40:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=sDa4TaQsXkZ3nk0bmyhl4NfV/hbR4r+Iv2W6zb66NbEEjx8DavLdJuu4EpjKY2XC6
	XTP49EDxfPkiwZbUXEGig==
MIME-Version: 1.0
Date: Tue, 15 Sep 2009 17:40:15 -0700
Message-ID: <6599ad830909151740n2affe0daw27618ccae9c737d6@mail.gmail.com>
Subject: Re: 2.6.32 -mm merge plans (cgroups)
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 4:15 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch
> cgroups-support-named-cgroups-hierarchies.patch
> cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
> cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
> cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch

I think these first five should be fine for merge.

> cgroups-revert-cgroups-fix-pid-namespace-bug.patch
> cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
> cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
> cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
> cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
> cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
> cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
> #cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch: Oleg conniptions
> cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
> cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
> cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch

How much longer is the merge window open for? It's probably safest to
hold these in -mm for now since we've not resolved the potential races
in the signal handler accesses; I'll try to find some time to work on
them this week or next.

Paul
