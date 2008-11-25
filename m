Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbYKYTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbYKYTjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 14:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYKYTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 14:39:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56892 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750816AbYKYTjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 14:39:04 -0500
Date: Tue, 25 Nov 2008 19:38:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [BUILD_FAILURE] linux-next: 20081125 - 8390 network driver
 build fails
Message-ID: <20081125193853.076c7b58@lxorguk.ukuu.org.uk>
In-Reply-To: <492C5334.2090801@oracle.com>
References: <20081125213738.881b425e.sfr@canb.auug.org.au>
	<20081125182542.GA4914@linux.vnet.ibm.com>
	<492C464D.4080704@oracle.com>
	<20081125185154.2845e8f1@lxorguk.ukuu.org.uk>
	<492C5334.2090801@oracle.com>
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

> The problem is that both 8390.c and 8390p.c #include lib8390.c
> and when they are both linked to built-in drivers (not loadable
> modules), the symbols in lib8390.c are duplicated.  I think.

And the symbols in question are static so are scoped within the file
only. Thats why it looks to me as if someone has done "#define static" in
another patch somewhere in -next.

Alan
