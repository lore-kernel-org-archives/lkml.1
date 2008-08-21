Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYHUPHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYHUPHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYHUPGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:06:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:37877 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYHUPGv (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hZwz5iGuxtCNBKLOKo7UQDSZFDHsNk7Zm7w8hocWh2PKO+5SjWQUeWdAkSgtjyoXtr
         pqlCdy2WYxA55JibGfitAew5xafQmDNZsjTtFm/XN1hAS9SWGwrKRFIBopv71oGtLYwM
         /hey5sqBLYgdjJ6+44dUzBkNmAe7imPcgr7Iw=
Message-ID: <6934efce0808210806r701f2e3bo677d2bd2da78faec@mail.gmail.com>
Date: Thu, 21 Aug 2008 08:06:50 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <200808211417.14425.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Have you seen any benefit of the rwsem over a simple mutex? I would guess
> that you can never even get into the situation where you get concurrent
> readers since I haven't found a single down_read() in your code, only
> downgrade_write()

We implemented a rwsem here because you can get concurrent readers.
My understanding is that downgrade_write() puts the rewem into the
same state as down_read().  Am I mistaken?
