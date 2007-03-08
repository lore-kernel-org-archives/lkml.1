Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbXCHR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbXCHR7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbXCHR7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:59:20 -0500
Received: from ozlabs.org ([203.10.76.45]:52498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbXCHR7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:59:20 -0500
Date: Thu, 8 Mar 2007 11:57:29 -0600
From: Anton Blanchard <anton@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070308175729.GA7054@kryten>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <20070308090031.GB7373@infradead.org> <1173369229.3550.2.camel@laptopd505.fenrus.org> <20070308160852.GB9916@infradead.org> <45F0426C.8000009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F0426C.8000009@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> By the way, it's a massive snafu that the swap area magic number is 
> dependent on PAGE_SIZE.  There is absolutely no good reason for that.

Agreed, its been a big problem booting between 4kB and 64kB kernels on
ppc64.

Anton
