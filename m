Return-Path: <linux-kernel-owner+w=401wt.eu-S1764117AbXILITA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764117AbXILITA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbXILISr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:18:47 -0400
Received: from ozlabs.org ([203.10.76.45]:57273 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbXILISq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:18:46 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH 01/15] Extract the file descriptor search logic in SPU coredump code
Date: Wed, 12 Sep 2007 18:17:42 +1000
User-Agent: KMail/1.9.6
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121817.43263.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

This series looks good to me, thanks for the fixes. I'll do some testing 
tomorrow but it looks like it'll be fine as-is.

Andrew - almost all of these are for spufs, the notable exception being:

 [PATCH 12/15] Cleanup ELF coredump extra notes logic

which touches the generic elf/coredump path.

Are you ok for me to merge this to my spufs tree, and upstream via 
paulus?

Cheers,


Jeremy
