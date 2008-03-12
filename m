Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYCLNxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYCLNxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYCLNx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:53:27 -0400
Received: from zux006-051-205.adsl.green.ch ([81.6.51.205]:12206 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259AbYCLNx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:53:26 -0400
Date: Wed, 12 Mar 2008 13:30:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080312133001.1668f40d@the-village.bc.nu>
In-Reply-To: <m3d4q08477.fsf@ursa.amorsen.dk>
References: <200803092346.17556.phillips@phunq.net>
	<200803110450.19390.phillips@phunq.net>
	<20080311215601.GM23784@marowsky-bree.de>
	<200803111602.53835.phillips@phunq.net>
	<m3d4q08477.fsf@ursa.amorsen.dk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Everyone who has write cache turned on for their hard drives is
> running in a mode similar to ramback anyway (except for when the file
> system is set to force writes to the platter, but that is rare).
> Admittedly, software crashes rarely cause the write cache to be lost,
> but hardware failures do, practically every time.

On the contrary - the hard disk cache is managed by the barrier logic in
the kernel, and the ordering even on failures is fairly predictable.

