Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYEaM0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYEaM0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 08:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYEaM0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 08:26:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53841 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751601AbYEaM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 08:26:13 -0400
Date: Sat, 31 May 2008 13:11:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Fink <billfink@mindspring.com>
Cc: James Cammarata <jimi@sngx.net>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
Message-ID: <20080531131143.516ca56e@core>
In-Reply-To: <20080530151250.b44a119a.billfink@mindspring.com>
References: <482DA5B6.1020606@sngx.net>
	<482DB46A.8020103@cosmosbay.com>
	<482EF192.4070707@sngx.net>
	<482F5113.5090703@cosmosbay.com>
	<482F610D.2080108@sngx.net>
	<20080518003104.GK28241@solarflare.com>
	<482FBA09.80201@sngx.net>
	<483E0AAE.2020107@sngx.net>
	<20080528221118.63da4092.akpm@linux-foundation.org>
	<483EA2D1.8050603@sngx.net>
	<20080529154525.3916c7b5@core>
	<20080530151250.b44a119a.billfink@mindspring.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When diagnosing network problems, the ability to zero counters is
> a major aid in diagnosis.  Writing scripts is not a general solution
> since often several systems are involved and it's not simple to do
> this via a script.  Saving stats output and running beforeafter on
> a number of systems is a royal pain when troubleshooting.

Zeroing them is not a general solution either - you break all the other
tools monitoring the same stats in parallel - like network usage monitors.

This is a user space tools problem, scripts or otherwise.

Alan
