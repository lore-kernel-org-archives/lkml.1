Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYIYIqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYIYIqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYIYIqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:46:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40990 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525AbYIYIqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:46:39 -0400
Date: Thu, 25 Sep 2008 09:45:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akataria@vmware.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alok kataria <alokkataria1@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080925094546.02839e66@lxorguk.ukuu.org.uk>
In-Reply-To: <1222320201.23524.135.camel@alok-dev1>
References: <20080221115452.GB13948@elte.hu>
	<20080907234510.GA24133@yantp.cn.ibm.com>
	<20080908140423.GG11993@elte.hu>
	<35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
	<48DB15DB.8040501@zytor.com>
	<1222317978.23524.117.camel@alok-dev1>
	<48DB1984.8020704@zytor.com>
	<1222318928.23524.121.camel@alok-dev1>
	<48DB1BCE.2070106@zytor.com>
	<1222320201.23524.135.camel@alok-dev1>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> have a real device there (a sane one), what can IN result in apart from
> reading some IO register/counter value in eax ?
> If there is anything apart from the above 2 outcomes, please let me know
> exactly what you mean.

Changing the status of the device that is actually at the port, losing
IRQs, hanging the bus solid, causing data corruption (eg if you probe the
address of the data port of something like a disk doing a block transfer)

Alan
