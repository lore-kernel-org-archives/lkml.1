Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752689AbYLQWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYLQWFA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYLQWEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:04:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYLQWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:04:49 -0500
Date: Wed, 17 Dec 2008 14:03:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] CGroups: Hierarchy locking/refcount changes
Message-Id: <20081217140318.c6832440.akpm@linux-foundation.org>
In-Reply-To: <20081216113055.713856000@menage.corp.google.com>
References: <20081216113055.713856000@menage.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 03:30:55 -0800
menage@google.com wrote:

> These patches introduce new locking/refcount support for cgroups to
> reduce the need for subsystems to call cgroup_lock(). This will
> ultimately allow the atomicity of cgroup_rmdir() (which was removed
> recently) to be restored.

OK, they merged OK.  We're accumulating rather a lot of cgroups work.

I have a question mark over these:

cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch

it wasn't clear to me whether you still had issues with them, or
whether updates were expected?

