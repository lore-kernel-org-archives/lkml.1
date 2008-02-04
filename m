Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYBDJoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYBDJoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 04:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYBDJo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 04:44:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbYBDJoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 04:44:25 -0500
Date: Mon, 4 Feb 2008 01:44:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: include/linux/pcounter.h
Message-Id: <20080204014402.1c55d3fe.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


e7d0362dd41e760f340c1b500646cc92522bd9d5 should have been folded into
de4d1db369785c29d68915edfee0cb70e8199f4c prior to merging.  We now and for
ever have a window of breakage which screws up git bisection.  Which I
just hit.  Which is the only reason I discovered the file's existence.


Please do not merge pieces of generic kernel infrastructure while keeping
it all secret on the netdev list.  Ever.  That code has a number of deficiencies
which I and probably others would have noted had it been offered to us
for review.
