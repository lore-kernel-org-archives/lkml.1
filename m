Return-Path: <linux-kernel-owner+w=401wt.eu-S1762128AbYDNR1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762128AbYDNR1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760471AbYDNR1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:27:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54434 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759565AbYDNR11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:27:27 -0400
Date: Mon, 14 Apr 2008 18:22:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Bob Copeland" <me@bobcopeland.com>
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080414182241.35546025@core>
In-Reply-To: <b6c5339f0804141018k100b6f68ob57b35a67c669e9c@mail.gmail.com>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080414091639.4bd3879d@core>
	<20080414084141.GA29113@infradead.org>
	<200804141020.37271.chris.mason@oracle.com>
	<b6c5339f0804140936s3dcce48en59a270dc86bf7dc8@mail.gmail.com>
	<20080414175158.5db84dcd@core>
	<b6c5339f0804141018k100b6f68ob57b35a67c669e9c@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 13:18:53 -0400
"Bob Copeland" <me@bobcopeland.com> wrote:

> On Mon, Apr 14, 2008 at 12:51 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> >  What does the replaytv byteswap - the entire blocks or some fields ?
> 
> Entire blocks (both meta- and normal data).  E.g. the filename 'Filename'
> would look like 'eliFeman' on disk.  I have a dm target that can do this
> gathering dust somewhere.

Thats what I was wondering. The dm target would be useful and is also
needed for certain old 68K boxes with libata
