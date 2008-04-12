Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbYDLMWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbYDLMWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbYDLMWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:22:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60876 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760035AbYDLMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:22:17 -0400
Subject: Re: modifying CFS failure
From: Peter Zijlstra <peterz@infradead.org>
To: cs044024@mnnit.ac.in
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <42423.210.212.49.15.1207972006.squirrel@mail.mnnit.ac.in>
References: <42423.210.212.49.15.1207972006.squirrel@mail.mnnit.ac.in>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 14:22:03 +0200
Message-Id: <1208002923.7427.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please provide it as a series of patches against sched-devel/latest.

Just plain AVL code and a huge modified CFS backport make it impossible
to tell what changed and why.

Which brings us to the question: _why_. That is, why are you trying to
replace the rb-tree with an avl tree? Just because the worst case depth
of the avl is slightly better than for an rb-tree, which can be offset
by the slightl more expesive balance operations.

I'm glad people are working on CFS - its an interesting piece of the
kernel after all, but provide it in a regular patch series, this is
impossible to work with, sorry.

