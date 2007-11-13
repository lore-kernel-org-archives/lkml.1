Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbXKMAPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbXKMAPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXKMAOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:14:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:33680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXKMAOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:14:50 -0500
From: Andreas Schwab <schwab@suse.de>
To: Tomasz =?iso-8859-2?Q?K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: top lies ?
References: <Pine.BSO.4.63.0711121843170.3123@rudy.mif.pg.gda.pl>
X-Yow: I've read SEVEN MILLION books!!
Date: Tue, 13 Nov 2007 01:14:48 +0100
In-Reply-To: <Pine.BSO.4.63.0711121843170.3123@rudy.mif.pg.gda.pl> ("Tomasz
	=?iso-8859-2?Q?K=B3oczko=22's?= message of "Mon\, 12 Nov 2007 18\:57\:39
 +0100 \(CET\)")
Message-ID: <jer6iv57d3.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz K³oczko <kloczek@rudy.mif.pg.gda.pl> writes:

> Some data showed by top command looks like completly trashed.
> Fragment from top output:
>
> Mem:   2075784k total,  2053352k used,    22432k free,    19260k buffers
> Swap:  2096472k total,      136k used,  2096336k free,  1335080k cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  SWAP nFLT WCHAN     COMMAND
> 14515 mysql     20   0 1837m 563m 4132 S   39 27.8  27:14.20 1.2g   18 -         mysqld
>
> How it is possible that swap ussage is 136k and swapped out portion of (in
> this case) mysqld process is 1.2g ?

SWAP is just VIRT - RES.  It means that 1.2g of the allocated virtual
address space is not resident, but it does not mean that all of it is
written to the swap space, it can also be part of a file based mapping.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
