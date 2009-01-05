Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZAEL2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZAEL2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZAEL2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:28:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46847 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753411AbZAEL2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:28:40 -0500
Date: Mon, 5 Jan 2009 11:28:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090105112822.704ab434@lxorguk.ukuu.org.uk>
In-Reply-To: <20090105094504.GB27199@atrey.karlin.mff.cuni.cz>
References: <20090103123813.GA1512@ucw.cz>
	<200901041349.49906.rob@landley.net>
	<20090104225545.GF1913@elf.ucw.cz>
	<yq1r63i30bv.fsf@sermon.lab.mkp.net>
	<20090105094504.GB27199@atrey.karlin.mff.cuni.cz>
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

> How much true is it for normal SATA drives? Are there some tests I can
> just run on a machine, powercycle it few times, and it tells me if my
> disk is non-ATOMIC-SECTORS?

No.

And even if it did writes to one sector can damage another. The
mathematical certainly stuff lives only in the world of maths. In the real
world everything is probabilities.

Alan
