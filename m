Return-Path: <linux-kernel-owner+w=401wt.eu-S1760400AbZAMN7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbZAMN7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZAMN7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:59:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44261 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682AbZAMN7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:59:21 -0500
Date: Tue, 13 Jan 2009 13:59:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan-Frode Myklebust <janfrode@tanso.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113135934.412288a3@lxorguk.ukuu.org.uk>
In-Reply-To: <slrngmp6fd.24m.janfrode@lc4eb5760521341.ibm.com>
References: <20090112153304.GA19995@ioremap.net>
	<20090112154922.6003750b@lxorguk.ukuu.org.uk>
	<20090112155030.GA21063@ioremap.net>
	<20090112155239.5f677a17@lxorguk.ukuu.org.uk>
	<20090112155615.GA21350@ioremap.net>
	<20090112161931.6203f96e@lxorguk.ukuu.org.uk>
	<20090112162938.GA22647@ioremap.net>
	<496BCB7A.2010804@tmr.com>
	<20090112231728.GA23803@ioremap.net>
	<alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com>
	<20090113085244.GA13796@ioremap.net>
	<alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
	<slrngmp6fd.24m.janfrode@lc4eb5760521341.ibm.com>
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

> +potential rouge process. F.ex. to make sure the process "Kenny" will be a
> +prime candidate to get killed:
> +
> +       echo 15 > /proc/self/oom_adj
> +       ./Kenny
> +       echo -15 > /proc/self/oom_adj
> +

This is a bogus and silly example - but it does show why the whole thing
is not needed

	(echo "15" >/proc/self/oom_adj; exec ./Kenny) &

See it's like nice, you can do it yourself anyway if you are
co-operating, and if you aren't co-operating you need containers anyway...

Alan
