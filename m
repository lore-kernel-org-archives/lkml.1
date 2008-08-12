Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYHLWpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYHLWpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYHLWpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:45:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbYHLWpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:45:40 -0400
Date: Tue, 12 Aug 2008 15:44:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: rjw@sisk.pl, menage@google.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] Container Freezer v6: Reuse Suspend Freezer
Message-Id: <20080812154429.c5377bd0.akpm@linux-foundation.org>
In-Reply-To: <20080811235323.872291138@us.ibm.com>
References: <20080811235323.872291138@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 16:53:23 -0700
Matt Helsley <matthltc@us.ibm.com> wrote:

> This patch series introduces a cgroup subsystem that utilizes the swsusp
> freezer to freeze a group of tasks. It's immediately useful for batch job
> management scripts. It should also be useful in the future for implementing
> container checkpoint/restart.

I don't think that this provides anything like sufficient detail to justify
merging a whole bunch of stuff into Linux.

What does "It's immediately useful for batch job management scripts."
mean?  How is it useful?  Examples?  Why would an operator want this
feature, and how would it be used?  _much_ more information is needed!

Once we've actually found out what this work is useful for, we can move
onto identification of and discussion of alternatives.  One would be "why not
use plain old SIGSTOP?"  Another alternative is, of course "that's not useful
enough to justify merging the code".  But we don't know yet, coz you didn't
tell us.
