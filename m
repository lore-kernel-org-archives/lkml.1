Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZDNHW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZDNHW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZDNHWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:22:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49883 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZDNHWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:22:18 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
From: Andi Kleen <andi@firstfloor.org>
References: <20090412091228.GA29937@elte.hu>
	<Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
	<20090412162018.6c1507b4@lxorguk.ukuu.org.uk>
	<49E213AE.4060506@redhat.com>
	<alpine.LFD.2.00.0904120950050.4583@localhost.localdomain>
	<49E2DC96.6090407@redhat.com>
	<alpine.LFD.2.00.0904130747440.4583@localhost.localdomain>
Date: Tue, 14 Apr 2009 09:22:13 +0200
In-Reply-To: <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain> (Linus Torvalds's message of "Mon, 13 Apr 2009 08:10:40 -0700 (PDT)")
Message-ID: <874owr8ztm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> You absolutely do _not_ want to manage memory in 16kB chunks (or 64kB for 
> your example!).

AFAIK at least for user visible anonymous memory Windows uses 64k 
chunks. At least that is what Cygwin's mmap exposes. I don't know
if it does the same for disk cache.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
