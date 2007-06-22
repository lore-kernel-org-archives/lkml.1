Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbXFVWPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbXFVWPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbXFVWOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:14:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48327 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755223AbXFVWOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:14:54 -0400
Date: Fri, 22 Jun 2007 23:19:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070622231951.4d516215@the-village.bc.nu>
In-Reply-To: <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
References: <200706221219.16243.yinghai.lu@sun.com>
	<20070622193124.GG5051@rhun.smartcity.com>
	<20070622213327.69663288@the-village.bc.nu>
	<m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> YH do you think you can look at simply reserving a portion of the iommu?
> And having the kexec on panic kernel use the reserved portion?

How about simply reserving all of it for the base kernel and using soft
iommu for the panic kernel, its hardly high performance criticial at this
point.
