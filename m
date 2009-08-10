Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbZHJHEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbZHJHEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZHJHEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:04:06 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59958 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZHJHEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:04:04 -0400
Subject: Re: mmotm 2009-08-06-00-30 uploaded (mtd)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Magnus Damm <damm@igel.co.jp>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
In-Reply-To: <20090807033448.GA32592@linux-sh.org>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
	 <20090806190233.6d4b4e28.randy.dunlap@oracle.com>
	 <20090806192513.53f6488b.akpm@linux-foundation.org>
	 <20090807033448.GA32592@linux-sh.org>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 10:01:35 +0300
Message-Id: <1249887695.19638.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2009 07:03:08.0481 (UTC) FILETIME=[9DA8C310:01CA1988]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 12:34 +0900, Paul Mundt wrote:
> [PATCH] mtd: onenand: select MTD_PARTITIONS.
> 
> All of the onenand drivers depend on mtd partition support being compiled
> in, so just select it. Fixes up build breakage:
> 
> drivers/built-in.o: In function `generic_onenand_remove':
> generic.c:(.devexit.text+0x80): undefined reference to `del_mtd_partitions'
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Hopefully someday we are going to remove this config options, remove
the mtdpart module, and make partitions mandatory. Currently it is
a mess, IMO.

I've just put this patch to my l2-mtd-2.6.git tree.

Artem.

