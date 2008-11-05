Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYKERFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYKERFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYKERFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:05:24 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:30439 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYKERFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:05:24 -0500
Date: Wed, 5 Nov 2008 09:04:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Peter Teoh <htmldeveloper@gmail.com>
Subject: Re: make htmldocs errors
Message-Id: <20081105090449.9701af72.randy.dunlap@oracle.com>
In-Reply-To: <4911CB47.6030809@oracle.com>
References: <804dabb00811050825td613b25lf400f4963e83e78c@mail.gmail.com>
	<4911CB47.6030809@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2008 08:35:19 -0800 Randy Dunlap wrote:

> Peter Teoh wrote:
> > This is on the latest linus tree (75fa67706cce5272bcfc51ed646f2da21f3bdb6e):
> > 
> > /mnt/hd0/download/linux-2.6-latest>make htmldocs
> > make[1]: *** No rule to make target `include/asm-x86/io_32.h', needed
> > by `Documentation/DocBook/deviceiobook.xml'.  Stop.
> > make: *** [htmldocs] Error 2
> 
> Hi,
> I thought that I had already fixed that, but I'll take another look
> at it.

Peter,
Please check again.  I suspect some files or the git tree is not current.

> git describe
v2.6.28-rc3-54-g75fa677

> grep asm-x86 Documentation/DocBook/deviceiobook.tmpl
# finds nothing

and I fixed this error here (in Linus's git tree):

commit a1a739c56ad031b8bf8b3804f568ac88899f8dd7
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Sat Oct 25 17:24:36 2008 -0700

    docbooks: fix fatal filename errors

---
~Randy
