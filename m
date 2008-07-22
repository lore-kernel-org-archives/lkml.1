Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYGVQwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYGVQwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYGVQvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:51:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44441 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751490AbYGVQvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:51:54 -0400
Date: Tue, 22 Jul 2008 17:34:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Firmware breakage
Message-ID: <20080722173420.6f90556d@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you crossbuild x86-32 on x86-64 and then attempt to do the install on
an x86-32 box the install now breaks. This used to work until the
firmware changes. Now you get

/bin/sh: scripts/basic/fixdep: cannot execute binary file

Fixdep should be built for the target platform surely ?

Alan
