Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYFPOlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYFPOlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759205AbYFPOk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:40:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41074 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbYFPOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:40:28 -0400
Message-ID: <48567B52.4050901@firstfloor.org>
Date: Mon, 16 Jun 2008 16:40:18 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, rth@twiddle.net
Subject: Re: [PATCH v2] export linux/a.out.h
References: <1213565555.26255.522.camel@pmac.infradead.org>	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk> <1213617663.26255.708.camel@pmac.infradead.org>
In-Reply-To: <1213617663.26255.708.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> ...and (indirectly, by virtue of being the only other file that includes
> <linux/a.out.h> when ARCH_SUPPORTS_AOUT might be unset) fs/binfmt_elf.c,
> which still has unnecessary references to 'struct exec' even though Andi
> removed the support for a.out interpreters a few months ago. That can
> just go away.

I didn't think the Alpha /sbin/loader stuff was an a.out interpreter for ELF.

Also pure a.out is still supported.

It might be ok to remove it anyways, but you should check with someone
who knows Alpha first. cc Richard.


-Andi
