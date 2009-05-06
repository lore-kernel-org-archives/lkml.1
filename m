Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbZEFOwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbZEFOwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760312AbZEFOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:12 -0400
Received: from mail.crca.org.au ([67.207.131.56]:32856 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759990AbZEFOs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:48:59 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Cc: Nigel Cunningham <nigel@tuxonice.net>
Subject: [RFC] TuxOnIce
Date: Thu,  7 May 2009 00:38:56 +1000
Message-Id: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to submit TuxOnIce for review, with a view to seeking to get it
merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
it can be merged) and the willingness of those who matter.

To briefly summarise the advantages to merging TuxOnIce:

- Support for multiple swap devices
- Support for non-swap (an ordinary file can be used)
- Uses cryptoapi (LZO support, more than 2x speed of uncompressed data!)
- Asynchronous I/O, readahead, multithreaded. Get the maximum throughput
  possible with your hardware.
- Userspace user interface that lets you abort hibernating and abort
  resuming, get nice progress display etc.
- 8 years of testing and improvement.
- Full image of memory (LRU pages that don't need to be atomically
  copied are saved prior to the atomic copy, then used as the
  destination of the atomic copy).
- Support for resuming a different image after writing an image - makes
  powering down a UPS after writing an image doable.
- Simple to set up (works without any userspace binaries, uses existing
  resume= and noresume commandline parameters).

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>


