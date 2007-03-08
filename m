Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXCHRJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXCHRJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXCHRJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:09:01 -0500
Received: from terminus.zytor.com ([192.83.249.54]:51518 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbXCHRJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:09:00 -0500
Message-ID: <45F0426C.8000009@zytor.com>
Date: Thu, 08 Mar 2007 09:05:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <20070308090031.GB7373@infradead.org> <1173369229.3550.2.camel@laptopd505.fenrus.org> <20070308160852.GB9916@infradead.org>
In-Reply-To: <20070308160852.GB9916@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> No, no no.  We should never export PAGE_SIZE.  We might export NBPG
> as deprecated symbol for gdb if it really needs it, but that should
> happen only on a.out systems, and it it should be a true constant,
> not depending on PAGE_SIZE.
> 
> I've Cc'ed the gdb list on whether they have any comments on this
> issue.

By the way, it's a massive snafu that the swap area magic number is 
dependent on PAGE_SIZE.  There is absolutely no good reason for that.

	-hp
