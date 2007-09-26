Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbXIZUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbXIZUCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbXIZUCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:02:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758800AbXIZUCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:02:07 -0400
Date: Wed, 26 Sep 2007 13:01:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, guichaz@yahoo.fr, balbir@in.ibm.com,
       jlan@engr.sgi.com, jlim@sgi.com, oleg@tv-sign.ru
Subject: Re: [PATCH 1/8] taskstats: fix indentation of long argument lists
Message-Id: <20070926130144.78ab9491.akpm@linux-foundation.org>
In-Reply-To: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
References: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 19:08:18 +0200
Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> Align with the opening parenthesis.
> 
> Changelog since V1 (http://lkml.org/lkml/2007/9/21/527):
> - renamed fill_threadgroup() and add_tsk() to respectively
> fill_threadgroup_stats() and add_tsk_stats() as suggested by Balbir Singh.
> - added braces around do/while.
> - added patch to unbreak binary compatibility between taskstats v5/v6.
> - split further by preparing the bacct/xacct before the main patch.
> - some indentation fixes.

It is unclear to me whether this patch series replaces, augments or
conflicts with your earlier patch series starting with "taskstats: separate
PID/TGID stats producers to complete the TGID ones".

But it doesn't matter much - I think I'll duck both patch series for now. 
The gap between mainline and -mm is so large that it is becoming
unmanageable so let's concentrate on the review and stabilisation work for
now please, rather than adding more stuff.

Also, I don't think we're seeing enough review and test from people on
these patch series - I don't have time to do it all.  (Well, apparently I
do, but I don't think it's a good situation).
