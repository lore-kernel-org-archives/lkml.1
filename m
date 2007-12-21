Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXLUCbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXLUCbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763669AbXLUCaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:30:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763559AbXLUCae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:30:34 -0500
Date: Thu, 20 Dec 2007 18:30:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] misc: Removal of final callers using fastcall
Message-Id: <20071220183029.86ac61e4.akpm@linux-foundation.org>
In-Reply-To: <1197502706.21291.49.camel@brick>
References: <1197502706.21291.49.camel@brick>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 15:38:26 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Andrew, I'm not sure who is best to hit with these final dribs and
> drabs removing fastcall.  Once all of these have hit Linus' tree
> I will send a final patch deleting the include/linux/linkage.h
> definitions as well as any remaining occurances.

Yes, that's a good approach, thanks.  Wait until the tree is fastcall-clean
and then kill the definition(s).

I think I skipped rather a lot of remove-fastcall patches because a)
suitable maintainers were cc'ed and b) I was going through a
suicidal-over-bug-reports phase.

Please keep them coming - I've always disliked fastcall.
