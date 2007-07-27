Return-Path: <linux-kernel-owner+w=401wt.eu-S937428AbXG0R3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937428AbXG0R3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763276AbXG0R3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:29:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38599 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763245AbXG0R27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:28:59 -0400
Date: Fri, 27 Jul 2007 18:35:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Subbu Seetharaman" <subbus@serverengines.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Source organization for two drivers sharing coomon code
Message-ID: <20070727183558.56c07db4@the-village.bc.nu>
In-Reply-To: <20070727171729.f3ff0878@mailhost.serverengines.com>
References: <20070727171729.f3ff0878@mailhost.serverengines.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 10:17:29 -0700
"Subbu Seetharaman" <subbus@serverengines.com> wrote:

> 
> 
> What is the recommended way for two drivers to share common code ?
> Our device has two PCI functions and hence two drivers -  NIC and 
> SCSI driver.   The source code for these dirvers will fit under 
> drivers/net and drivers/scsi.  But both drivers share some common 
> code.  If possible, I would like to avoid duplicating the common 
> code under the two driver directories.   Is there any recommened 
> way to organize such common  code ?  Thanks.

What sort of code is shared - historically the cases we have had in the
driver space have mostly been common message passing interfaces to
co-processor type boards (eg I2O or MPT Fusion) and those have lived
under drivers/message/type/...

I don't think there is any hard rule here.

Alan
