Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZBCRz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZBCRz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZBCRyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:54:53 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45836 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZBCRyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:54:51 -0500
X-Greylist: delayed 3882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 12:54:48 EST
Date: Tue, 3 Feb 2009 17:21:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: wenji.huang@oracle.com, linux-serial@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the warning of uninitialized value in
 driver/serial/8250.c
Message-ID: <20090203172147.18136ed1@the-village.bc.nu>
In-Reply-To: <200902021103.21887.laurentp@cse-semaphore.com>
References: <4986B86E.3030604@oracle.com>
	<200902021103.21887.laurentp@cse-semaphore.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> gcc is wrong, i can't be used uninitialized in that function. You should use 
> the following construct instead to suppress the warning without generating any 
> code.

No need for that either - newer gcc gets it right.
