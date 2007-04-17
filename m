Return-Path: <linux-kernel-owner+w=401wt.eu-S1030752AbXDQUMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030752AbXDQUMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031151AbXDQUMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:12:20 -0400
Received: from relay5.ptmail.sapo.pt ([212.55.154.25]:34486 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1030752AbXDQUMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:12:19 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 16:12:19 EDT
X-AntiVirus: PTMail-AV 0.3-0.90.1
Message-ID: <46252891.6080701@wizy.org>
Date: Tue, 17 Apr 2007 21:05:37 +0100
From: Ricardo Correia <linux-kernel@wizy.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Florian Weimer <fw@deneb.enyo.de>
CC: Theodore Tso <tytso@mit.edu>, Daniel Hazelton <dhazelton@enter.net>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>	<20070417131045.GB18373@thunk.org>	<Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>	<200704171222.19892.dhazelton@enter.net>	<20070417175055.GA24963@thunk.org> <87odlmrei0.fsf@mid.deneb.enyo.de> <46252675.9010201@wizy.org>
In-Reply-To: <46252675.9010201@wizy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ricardo Correia wrote:
> That FAQ entry is outdated, ZFS can recover from metadata corruption on
> non-replicated pools for a long time already.

Just a clarification, ZFS not only detects metadata corruption through
the use of checksums but, since it keeps 2-3 copies of each metadata
block on-disk (even on non-replicated pools), it also rewrites the
corrupted blocks, effectively repairing the corruption.

All of this is done transparently to the user but, of course, it's
possible to see a report of checksum failures.

