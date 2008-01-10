Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYAJAeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYAJAeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYAJAeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:34:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbYAJAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:34:06 -0500
Date: Wed, 9 Jan 2008 16:33:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Denis Cheng <crquan@gmail.com>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, emdow@us.ibm.com
Subject: Re: [PATCH] PROC_FS: get and set the smp affinity of tasks by
 read-write /proc/<pid>/smp_affinity
Message-Id: <20080109163350.79a4c346.akpm@linux-foundation.org>
In-Reply-To: <1199430221-28417-1-git-send-email-crquan@gmail.com>
References: <1199430221-28417-1-git-send-email-crquan@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jan 2008 15:03:41 +0800
Denis Cheng <crquan@gmail.com> wrote:

> this adds a read-write /proc/<pid>/smp_affinity entry,
> just like what /proc/irq/<irq>/smp_affinity does,
> so now we can get and set the affinity of tasks by procfs,
> this is especially useful used in shell scripts.
> 
> this also adds a read-write /proc/<pid>/tasks/<tid>/smp_affinity
> for the same purpose.

Why not use /usr/bin/taskset?
