Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbYA1Noq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbYA1Noq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYA1Noi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:44:38 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35918 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755188AbYA1Nog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:44:36 -0500
Date: Mon, 28 Jan 2008 13:38:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Steve French <smfrench@gmail.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Message-ID: <20080128133857.6c53ac9f@core>
In-Reply-To: <200801281427.36048.ak@suse.de>
References: <20080127317.043953000@suse.de>
	<20080127211345.6e73fa0b.akpm@linux-foundation.org>
	<20080128125605.299740a1@core>
	<200801281427.36048.ak@suse.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also worse really fixing it would be a major change to the VFS 
> because of the way ->read/write are defined :/

I don't see a problem there. ->read and ->write update the passed pointer
which is not the real f_pos anyway. Just the copies need fixing.

Alan
