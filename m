Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZDLPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZDLPUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 11:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZDLPU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 11:20:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48286 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754147AbZDLPU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 11:20:28 -0400
Date: Sun, 12 Apr 2009 16:20:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Szabolcs Szakacsits <szaka@ntfs-3g.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
Message-ID: <20090412162018.6c1507b4@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
References: <20090412091228.GA29937@elte.hu>
	<Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The atomic building units (sector size, block size, etc) of NTFS are 
> entirely parametric. The maximum values could be bigger than the 
> currently "configured" maximum limits. 

That isn't what bites you - you can run 8K-32K ext2 file systems but if
your physical page size is smaller than the fs page size you have a
problem.

The question is whether the NT VM can cope rather than the fs.

Alan
