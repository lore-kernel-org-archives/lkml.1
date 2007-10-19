Return-Path: <linux-kernel-owner+w=401wt.eu-S937410AbXJST75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937410AbXJST75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936485AbXJST6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:58:52 -0400
Received: from anyanka.rfc1149.net ([81.56.47.149]:63299 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937182AbXJST6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:58:51 -0400
Date: Fri, 19 Oct 2007 21:58:47 +0200
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-mtd@lists.infradead.org, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eccbuf is statically defined and always evaluate to
	true
References: <20071019174155.80782C408E@mail2.rfc1149.net> <20071019190604.GJ26913@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071019190604.GJ26913@lazybastard.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Samuel Tardieu <sam@rfc1149.net>
Organization: RFC 1149 (see http://www.rfc1149.net/)
X-WWW: http://www.rfc1149.net/sam
X-Jabber: <sam@rfc1149.net> (see http://www.jabber.org/)
X-OpenPGP-Fingerprint: 79C0 AE3C CEA8 F17B 0EF1  45A5 F133 2241 1B80 ADE6 (see http://www.gnupg.org/)
Message-Id: <2007-10-19-21-58-47+trackit+sam@rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/10, Jörn Engel wrote:

| I assume you don't actually use this driver and just ran make
| randconfig or allyesconfig or so..

I tried the latest svn tip of GCC and it looks like this warning is
quite recent (and I happened to have this driver enabled as a module
in my kernel):

drivers/mtd/devices/doc2000.c: In function ‘doc_read’:
drivers/mtd/devices/doc2000.c:635: warning: the address of ‘eccbuf’ will always evaluate as ‘true’
drivers/mtd/devices/doc2000.c: In function ‘doc_write’:
drivers/mtd/devices/doc2000.c:899: warning: the address of ‘eccbuf’ will always evaluate as ‘true’
drivers/mtd/devices/doc2001plus.c: In function ‘doc_write’:
drivers/mtd/devices/doc2001plus.c:751: warning: the address of ‘eccbuf’ will always evaluate as ‘true’

