Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbXFDPg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbXFDPg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXFDPgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:36:51 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44928 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbXFDPgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:36:50 -0400
Subject: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
From: Richard Purdie <rpurdie@openedhand.com>
To: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>,
       Nitin Gupta <nitingupta910@gmail.com>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 16:36:18 +0100
Message-Id: <1180971378.6313.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following series contains several patches which I'm hoping could see
some testing in -mm. They're all been seen before at some point. The LZO
ones are important due to the dependent patches, the swap write failure
ones have just fallen off the radar.

LZO
===

We've seen a lot of activity in attempts to rewrite this in a
CodingStyle compatible 'clean' kernel style. The last update I read has
convinced me this is not ready for kernel usage at this time,
particularly due to the memory alignment issues.

I would like to see a version merged in the next merge window so other
patches depending on it can follow. If a better LZO implementation is
eventually sorted out, it can replace the lzo core in due course, the
API will be interchangeable. 

I've trimmed my patch down to only contain the "safe" decompression
function, pruned the headers a little further and merged in the cleanup
patch I submitted to -mm previously. I've also included an updated
version of the patch to make resier4 use the shared LZO functions
(fixing a security hole in the process).

Swap Write Failures
===================

Currently write failures to swap are handled badly and these patches
allow more graceful handling. 

These have been looked at before by various people and have no known
issues I'm aware of. I don't think Hugh has time to review these so if
anyone else familiar with the appropriate code area could look over
them, I'd appreciate it.

-- 
Richard






