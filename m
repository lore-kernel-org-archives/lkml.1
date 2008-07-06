Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYGFQZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYGFQZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYGFQZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:25:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42657 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757244AbYGFQZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:25:34 -0400
Date: Sun, 6 Jul 2008 17:08:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706170802.61131618@lxorguk.ukuu.org.uk>
In-Reply-To: <20080706192233.5df9c65b@linux360.ro>
References: <20080705131924.GA2083@joi>
	<20080705235148.GW28946@ZenIV.linux.org.uk>
	<20080706001148.GX28946@ZenIV.linux.org.uk>
	<20080706040519.GZ28946@ZenIV.linux.org.uk>
	<m1hcb31p8p.fsf@frodo.ebiederm.org>
	<20080706081126.GA28946@ZenIV.linux.org.uk>
	<20080706192233.5df9c65b@linux360.ro>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMHO, there is one reason ppdev exists: allow both _safe_ and _raw_
> access to the parallel port, and a much better alternative to the iopl
> stuff.

And various devices support sharing protocols on the parallel port.
