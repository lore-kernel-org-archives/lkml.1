Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbZANNVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbZANNVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758042AbZANNV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:21:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48417 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757554AbZANNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:21:28 -0500
Date: Wed, 14 Jan 2009 13:21:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Pierre Habouzit <pierre.habouzit@intersec.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: if backlog is 0, listening shall not be
 deactivated.
Message-ID: <20090114132124.15b68481@lxorguk.ukuu.org.uk>
In-Reply-To: <496DE5ED.8030609@hp.com>
References: <1231926123-26196-1-git-send-email-pierre.habouzit@intersec.com>
	<496DE5ED.8030609@hp.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However SCTP API explicitly states that when the backlog is 0, listening is
> disabled.  Here is an excerpt from the draft describing this:

POSIX is an established standard, SCTP is a draft proposal. POSIX should
win. The SCTP developers need to bring their draft API into alignment with
POSIX.

They need to fix their draft to use a sockopt or similar to
enable/disable listening.

