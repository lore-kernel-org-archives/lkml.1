Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYHVD3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYHVD3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYHVD3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:29:44 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:64508 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbYHVD3o (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:29:44 -0400
Message-ID: <48AE32AE.9010901@lougher.demon.co.uk>
Date: Fri, 22 Aug 2008 04:29:50 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de>	 <48AE22F5.3000309@lougher.demon.co.uk> <6934efce0808212023x758babf0w500da6801bd66f45@mail.gmail.com>
In-Reply-To: <6934efce0808212023x758babf0w500da6801bd66f45@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:

> 
> The memcpy in question copies a c_node to the page.  The len is either
> the max length of a c_node and size of the buffer I'm copying to
> (PAGE_CACHE_SIZE) or it is the difference between the beginning of the
> c_node in the c_block and the end of the c_block, whichever is
> smaller.  The confusion is probably because of the fact that this
> copies extra crap to the page for tails.


Ah yes, that's where I got confused :)  Glad to see AXFS uses tail packing.


Phillip
