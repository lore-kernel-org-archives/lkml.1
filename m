Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYCJWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYCJWJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYCJWIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:08:52 -0400
Received: from openfortress.nl ([213.189.19.244]:44517 "EHLO fame.vanrein.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753273AbYCJWIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:08:51 -0400
Date: Mon, 10 Mar 2008 22:07:05 +0000
From: Rick van Rein <rick@vanrein.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080310220705.GB27356@phantom.vanrein.org>
References: <182234194@web.de> <200803101224.07628.dl9pf@gmx.de> <20080310115237.GA29197@elf.ucw.cz> <200803101523.03620.dl9pf@gmx.de> <47D56DD3.8060108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D56DD3.8060108@zytor.com>
X-My-Coolest-Hack: http://rick.vanrein.org/linux/badram -> Exploit broken RAM
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> >badram=0x18690000,0xffff0000
> >(which means a whole from 0x18690000 to 0x1869ffff )
> 
> memmap=0x18690000$64K
> 
> 	or
> 
> memmap=0x18690000$0x10000

The true challenge, of course, is to map things like these:

badram=0x18fedcba36,0xfffecff6a

This is a repetitive pattern, and this is why people enjoy the syntactic
sugar of BadRAM (which is penciled down from the output of memtest86).
It appears to be the prevailing wind in this discussion that the patch
must be rewritting to make series of amandments as a long series of
memmap would do, and I'll take on that task.

Cheers,
 -Rick
