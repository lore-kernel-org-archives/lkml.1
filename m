Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbXLTVdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbXLTVdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbXLTVdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:33:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43573 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753393AbXLTVdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:33:43 -0500
Date: Thu, 20 Dec 2007 21:07:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Joe Perches <joe@perches.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071220210741.6dc3caf5@the-village.bc.nu>
In-Reply-To: <20071220162923.GB27885@shadowen.org>
References: <474E6BD0.20103@cn.fujitsu.com>
	<E1IxfE8-0000Sr-9w@faramir.fjphome.nl>
	<474E8669.6060409@cn.fujitsu.com>
	<200711291120.19595.elendil@planet.nl>
	<20071129032036.4c021617.akpm@linux-foundation.org>
	<474F6372.70705@cn.fujitsu.com>
	<1196386259.22120.101.camel@localhost>
	<474F6D4D.9010006@cn.fujitsu.com>
	<1196390128.22120.118.camel@localhost>
	<20071220162923.GB27885@shadowen.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I missed the context on this one.  So this is checking for periods at
> the end of messages for printk's.  We would need something a little
> cleverer to ensure we are only checking the contents of the string.  But
> eminently doable.
> 
> /me plays
> 
> Ok, yes this seems ok.  Have added it for 0.13.

Please remove it.

The kernel printk messages are sentences. English language sentences end
with a full stop. They are messages printed up for normal human beings to
read and they should therefore be properly written.

In fact you should warn if it ends with a newline without a full stop
unless the next line is continuation of quoted text because that suggests
a full stop has been missed out incorrectly.

Alan
