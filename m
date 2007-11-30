Return-Path: <linux-kernel-owner+w=401wt.eu-S934894AbXK3Njg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894AbXK3Njg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXK3Nj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:39:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52763 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757166AbXK3NjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:39:25 -0500
Date: Fri, 30 Nov 2007 13:30:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Jon Masters <jonathan@jonmasters.org>, Ray Lee <ray-lk@madrabbit.org>,
       tvrtko.ursulin@sophos.com, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071130133052.5fdab6f4@the-village.bc.nu>
In-Reply-To: <21029.1196403614@turing-police.cc.vt.edu>
References: <20071128183040.GW8181@ftp.linux.org.uk>
	<OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
	<20071129173601.34273083@the-village.bc.nu>
	<2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com>
	<1196362612.6473.98.camel@perihelion>
	<2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
	<1196365551.6473.103.camel@perihelion>
	<20071129214527.1d62056c@the-village.bc.nu>
	<1196379273.6473.121.camel@perihelion>
	<21029.1196403614@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Fortunately for all concerned, although Alan's self-modifying code is indeed a
> possibility, it's much less of an issue than the sort of malware that can be
> found with a simple "find this 27-byte sequence, which will be found in either
> block 36 or 37 of the file"

Thats a very old model of detection ;)


There is another usage case for this stuff as well - which is on the fly
indexing of material. An indexer has the same basic needs as a virus
checker (without the blocking aspect) and doesn't have to be robust
against sneaky material.

Alan
