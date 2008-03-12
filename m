Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYCMKZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYCMKZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYCMKZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:25:08 -0400
Received: from zux006-051-205.adsl.green.ch ([81.6.51.205]:11893 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480AbYCMKZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:25:06 -0400
X-Greylist: delayed 76607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 06:24:57 EDT
Date: Wed, 12 Mar 2008 12:44:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH -mm] ne2: needs more 8390 support functions
Message-ID: <20080312124412.6089948c@the-village.bc.nu>
In-Reply-To: <20080311095643.01cd3708.randy.dunlap@oracle.com>
References: <20080311095643.01cd3708.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 09:56:43 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ne2 (MCA) needs both 8390.o and 8390p.o functions:

NAK - the two modules are alternatives nothing should use both - is 8390p
not sufficient ?
