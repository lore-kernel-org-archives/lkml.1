Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZERKDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZERKDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZERKDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:03:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35375 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751991AbZERKDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:03:21 -0400
Date: Mon, 18 May 2009 11:03:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by
 check_readable_bytes()
Message-ID: <20090518110359.0da1e6a7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090518094808.GA12041@shareable.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
	<1242317939-15392-3-git-send-email-v.mayatskih@gmail.com>
	<87k54iq2gv.fsf@basil.nowhere.org>
	<871vqqkdf0.wl%vmayatsk@redhat.com>
	<20090515093838.GB16682@one.firstfloor.org>
	<20090515134315.GB8235@shareable.org>
	<20090518093136.152a1bb7@lxorguk.ukuu.org.uk>
	<20090518094808.GA12041@shareable.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On MMUless you wouldn't use page protection as a GC technique :-)
> Is EFAULT really optional on systems with page protection?

Yes.

It's also not guaranteed under Linux although pretty much all our I/O
paths do bother to report -EFAULT

