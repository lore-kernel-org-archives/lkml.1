Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYJUTWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYJUTWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYJUTWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:22:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbYJUTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:22:44 -0400
Date: Tue, 21 Oct 2008 12:21:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: torvalds@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, tglx@linutronix.de, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu, hpa@zytor.com,
       viro@zeniv.linux.org.uk, orenl@cs.columbia.edu
Subject: Re: [RFC v7][PATCH 0/9] Kernel based checkpoint/restart
Message-Id: <20081021122135.4bce362c.akpm@linux-foundation.org>
In-Reply-To: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 01:40:28 -0400
Oren Laadan <orenl@cs.columbia.edu> wrote:

> These patches implement basic checkpoint-restart [CR]. This version
> (v7) supports basic tasks with simple private memory, and open files
> (regular files and directories only).

This is a problem.  I wouldn't want to be in a position where we merge
this code in mainline, but it's just a not-very-useful toy.  Then, as
we turn it into a useful non-toy it all turns into an utter mess.

IOW, merging this code as-is will commit us to merging more code which
hasn't even been written yet.  It might even commit us to solving
thus-far-unknown problems which we don't know how to solve!

It's a big blank cheque.

So.

- how useful is this code as it stands in real-world usage?

- what additional work needs to be done to it?  (important!)

- how far are we down the design and implementation path with that new
  work?  Are we yet at least in a position where we can say "yes, this
  feature can be completed and no, it won't be a horrid mess"?

