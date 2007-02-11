Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbXBKGql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbXBKGql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbXBKGql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:46:41 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:37243 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbXBKGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=W4ZjTfH4jy2KdK/eFh+55SbJtBR/6qybjrmfxfGDGGLW0PPbhsFroeKAkCgismhT9hIY9IqaL2mHG28c9Bfqr8bvETFs2MnJqemsACz4MtT0v57WOlMhaxRqipj5EH4CvGd94781iPXwwW3ulNx7ahETwgUIHS/cykpY6bBg3G8=
Message-ID: <45CEBBBB.6010107@gmail.com>
Date: Sun, 11 Feb 2007 01:46:19 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com> <20070211034902.GA9077@infradead.org> <45CEB720.1020406@gmail.com> <20070211063431.GS10050@ftp.linux.org.uk>
In-Reply-To: <20070211063431.GS10050@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> My current version:
> 
> From 97f115834b5ebef4f04e0f18aaa10f78f43733a0 Mon Sep 17 00:00:00 2001
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Sat, 10 Feb 2007 23:41:09 -0500
> Subject: [PATCH] sort the devres mess out
> 
> Split the implementation-agnostic stuff in separate files.
> Make sure that targets using non-default request_irq() pull kernel/irq/devres.o
> Mark targets that have no ioport_map() and friends, protect the ioport-related
> Parts of lib/devres.o with corresponding ifdef (BTW, we need it in driver
> dependencies in quite a few of cases, so that symbol was needed anyway).
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks.  Sorry about causing trouble for many archs.  :-)

-- 
tejun
