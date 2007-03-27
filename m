Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbXC0MRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbXC0MRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 08:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbXC0MRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 08:17:15 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:24513 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbXC0MRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 08:17:14 -0400
Message-ID: <46090B40.6080409@tls.msk.ru>
Date: Tue, 27 Mar 2007 16:17:04 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Yakov Lerner <iler.ml@gmail.com>
CC: Kernel Linux <linux-kernel@vger.kernel.org>
Subject: Re: glibc vs 2.6/2.4
References: <f36b08ee0703241106n7b8dd952p46d16a7c41abb4cd@mail.gmail.com>
In-Reply-To: <f36b08ee0703241106n7b8dd952p46d16a7c41abb4cd@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yakov Lerner wrote:
> Can I build recent glibc such that it will work both on
> 2.6 and on 2.4 ? (multithreading-wise, I suppose). I tried
> to boot recent 2.6-based distro with 2.4 kernel and it did not work.
> 
> Do I need to set some env.vars maybe (LD_ASSUME_KERNEL ?
> GNU_LIBPTHREAD_VERSION ?) for glibc when I switch kernels ?

Recent GLIBC README files mentions this explicitly: it does not
work with kernel 2.4 and earlier, for which, one have to use
glibc 2.3.

/mjt
