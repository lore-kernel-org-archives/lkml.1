Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXIQQ1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXIQQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXIQQ1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:27:17 -0400
Received: from nef2.ens.fr ([129.199.96.40]:1127 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXIQQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:27:17 -0400
X-Greylist: delayed 2120 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 12:27:17 EDT
Date: Mon, 17 Sep 2007 17:51:49 +0200
From: David Madore <david.madore@ens.fr>
To: linux-kernel@vger.kernel.org
Subject: patch/option to wipe memory at boot?
Message-ID: <20070917155149.GA5453@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Mon, 17 Sep 2007 17:51:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a patch or a boot option or something which wipes all
available (physical) RAM at boot (or better, fills it with a fixed
signature like 0xdeadbeef)?  I'm getting phony ECC errors and I'd like
to test whether they go away when the RAM is properly initialized.
Also, I'd like to know exactly which parts of RAM are being used and
which are untouched since boot (hence the 0xdeadbeef signature).

If this patch/option doesn't exist, can anyone give me a hint as to
where and how it would be best to add this?  (I'm afraid I'm very
ignorant as to how Linux sets up its RAM mapping.)  I'm concerned
about x86 and x86_64.

PS: I'm not finicky: it's all right if a couple of megabytes at the
bottom of RAM are not scrubbed (I'm more interested about the top
gigabyte-or-so), especially if they're guaranteed to be used by the
kernel.

Happy hacking,

-- 
     David A. Madore
    (david.madore@ens.fr,
     http://www.madore.org/~david/ )
