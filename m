Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbXJAJ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbXJAJ1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbXJAJ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:27:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45882 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbXJAJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:27:00 -0400
Date: Mon, 1 Oct 2007 02:26:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: roel <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] removes array_size duplicates
Message-Id: <20071001022653.40bd5714.akpm@linux-foundation.org>
In-Reply-To: <46FC33E1.8010309@tiscali.nl>
References: <46FC33E1.8010309@tiscali.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 00:51:13 +0200 roel <12o3l@tiscali.nl> wrote:

> This patch removes some ARRAY_SIZE macro duplicates. There is also one in
> arch/um/include/user.h, which isn't fixed here because comments in that file
> explicitly state a preference for the 'less fancy' version. If that's the
> case as well for any of the other replacements please comment.

I got a bunch of rejects against various development trees, a 
build error in net/ipv4/ipvs/ip_vs_proto_udp.c and now

net/netfilter/xt_sctp.c: In function 'match_packet':
net/netfilter/xt_sctp.c:58: error: size of array 'type name' is negative
net/netfilter/xt_sctp.c:106: error: size of array 'type name' is negative
