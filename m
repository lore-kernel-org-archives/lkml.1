Return-Path: <linux-kernel-owner+w=401wt.eu-S1750998AbXBLAXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbXBLAXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXBLAXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:23:09 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45013 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750998AbXBLAXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:23:08 -0500
Date: Sat, 10 Feb 2007 00:34:50 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Message-ID: <20070210003450.6fcdfd67@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0702091608120.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
	<45CD0C07.5060601@cosmosbay.com>
	<Pine.LNX.4.64.0702091608120.8424@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think we only do it for fget_light and some VM TLB simplification, so it 
> shouldn't be a big burden to check.

And all the permission management stuff that relies on one thread not
being able to manipulate the uid/gid of another to race security checks.

Alan
