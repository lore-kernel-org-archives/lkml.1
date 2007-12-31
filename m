Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbXLaWUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbXLaWUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 17:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXLaWUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 17:20:43 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41345 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXLaWUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 17:20:42 -0500
Date: Mon, 31 Dec 2007 23:20:40 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Patrick Mau <mau@oscar.ping.de>
cc: Bodo Eggert <7eggert@gmx.de>, Adrian Bunk <bunk@kernel.org>,
       devzero@web.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
In-Reply-To: <20071231174302.GA1627@oscar.prima.de>
Message-ID: <Pine.LNX.4.64.0712312316050.28123@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
 <20071231122419.GA13803@does.not.exist> <alpine.LSU.0.999.0712311335210.3761@be1.lrz>
 <20071231144255.GB13803@does.not.exist> <alpine.LSU.0.999.0712311553530.4211@be1.lrz>
 <Pine.LNX.4.64.0712311628330.28123@fbirervta.pbzchgretzou.qr>
 <20071231174302.GA1627@oscar.prima.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 31 2007 18:43, Patrick Mau wrote:
>
>May I ask something that might be obvious for most of the
>development community:
>
>Modules have to be loaded in seperate pages, right ?

That seems to be the case, judging from /proc/modules always ending in 000,
meaning each module is aligned at 0x1000 (4096, a page on i386).

Additionally, it looks like 48% of all kernel symbols (from System.map)
are aligned to 16 byte boundaries (what a waste! ;-))
