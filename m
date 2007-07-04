Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbXGDTFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbXGDTFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbXGDTFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:05:11 -0400
Received: from [84.243.56.243] ([84.243.56.243]:48713 "EHLO aurora.bayour.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756357AbXGDTFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:05:09 -0400
From: Turbo Fredriksson <turbo@bayour.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Moving MD/LVM from PPC to x86
Organization: Bah!
References: <87wsxneqs0.fsf@pumba.bayour.com>
	<20070629215416.GA12786@agk.fab.redhat.com>
	<876455erlw.fsf@pumba.bayour.com>
	<18054.9063.45466.586046@notabene.brown>
X-PGP-Fingerprint: B7 92 93 0E 06 94 D6 22  98 1F 0B 5B FE 33 A1 0B
X-PGP-Key-ID: 0x788CD1A9
X-URL: http://www.bayour.com/
Date: Wed, 04 Jul 2007 21:05:06 +0200
In-Reply-To: <18054.9063.45466.586046@notabene.brown> (Neil Brown's message of
	"Sat, 30 Jun 2007 19:33:27 +1000")
Message-ID: <87ejjo7zx9.fsf@pumba.bayour.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Neil Brown <neilb@suse.de>:

> Firstly, use
>    mdadm --examine --metadata=0.swap /dev/DEVICE

This should be done on the PPC, or can it be done on the Intel?

Tried this command on some other machines, and there the '--metadata'
is an unknown option... This on mdadm v1.9.0.

> Then
>   mdadm --assemble /dev/md0 --update=byteorder /dev/DEV0 /dev/DEV1  ....

And this on the Intel?
