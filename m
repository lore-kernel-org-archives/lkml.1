Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbYHSUSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbYHSUSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYHSUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:18:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbYHSUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:18:23 -0400
Message-ID: <48AB2A4A.7040103@linux-foundation.org>
Date: Tue, 19 Aug 2008 15:17:14 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with	_RET_IP_.
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro> <48AB0D69.4090703@linux-foundation.org> <20080819182423.GA5520@localhost> <48AB1769.3040703@linux-foundation.org> <48AB1A5B.3020305@cs.helsinki.fi>
In-Reply-To: <48AB1A5B.3020305@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:

> This looks wrong. The '%pS' thingy has a special purpose:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7daf705f362e349983e92037a198b8821db198af

True. Just had 10 minutes to do the patch. Can someone stitch all of the good
things from all three patches together?



