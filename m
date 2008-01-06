Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbYAFWru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbYAFWru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbYAFWrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:47:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38639 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755686AbYAFWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:47:40 -0500
Date: Sun, 6 Jan 2008 22:43:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linda Walsh <lkml@tlinx.org>
Cc: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
Message-ID: <20080106224340.3aff293c@lxorguk.ukuu.org.uk>
In-Reply-To: <47813926.6010908@tlinx.org>
References: <fa.o9uy6Qaq3PtHs2Z9lAKGUKvD85I@ifi.uio.no>
	<fa.1kDEq2SPE3FqpM5Mfw9CVGbvVdY@ifi.uio.no>
	<fa.hIZ5+XhGRugySB/HuLxr5qd6gAY@ifi.uio.no>
	<fa.iefWPg3R6g5Pnm/ktSCK9XWVFVw@ifi.uio.no>
	<fa.FhpaleM/osLTMJ85/PuxjxyJeGI@ifi.uio.no>
	<fa.MP5rgMp4TS2+Cfemd/uFOQOuquQ@ifi.uio.no>
	<477D9B6E.7060000@shaw.ca>
	<477D9D66.3080502@tlinx.org>
	<477DA05F.4080503@shaw.ca>
	<47813926.6010908@tlinx.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jan 2008 12:25:10 -0800
Linda Walsh <lkml@tlinx.org> wrote:

> Robert Hancock wrote:
> >
> > If this is a Seagate, I believe that they don't have AAM enabled on 
> > any of their newer drives (something about a lawsuit for patent 
> > infringement on that feature, or something). Quite likely they don't 
> > support that power management command, either.
> --
>     Do you have a source for this -- haven't heard of such a conflict -- 

There were patent questions around AAM. There are some discussions on the
t13 archive then it goes silent and nothing is ever said again, which I
imagine is when it got lawyered.

> besides, doesn't
> ATA-7 require some of those functions? 

No.

Alan
