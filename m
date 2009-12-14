Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbZLNRuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbZLNRuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932271AbZLNRue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:50:34 -0500
Received: from mail.vyatta.com ([76.74.103.46]:54369 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbZLNRud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:50:33 -0500
Date: Mon, 14 Dec 2009 09:50:06 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Stephen Clark <sclark46@earthlink.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH v3] Documentation: rw_lock lessons learned
Message-ID: <20091214095006.5cfc57a0@nehalam>
In-Reply-To: <4B254ABE.9040002@gmail.com>
References: <4B254ABE.9040002@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009 15:12:46 -0500
William Allen Simpson <william.allen.simpson@gmail.com> wrote:

> In recent months, two different network projects erroneously
> strayed down the rw_lock path.  Update the Documentation
> based upon comments by Eric Dumazet and Paul E. McKenney in
> those threads.
> 
> Further updates await somebody else with more expertise.
> 
> Changes:
>   - Merged with extensive content by Stephen Hemminger.
>   - Fix one of the comments by Linus Torvalds.
> 
> Signed-off-by: William.Allen.Simpson@gmail.com
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>   Documentation/spinlocks.txt |  184 ++++++++++++++++++++-----------------------
>   1 files changed, 84 insertions(+), 100 deletions(-)

The whole document needs a writer to go over it and make it readable.
Something like an updated chapter on locking from LDD3 book.
John? Randy?
