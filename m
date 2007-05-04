Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbXEDLgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbXEDLgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXEDLgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:36:36 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46514 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXEDLgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:36:35 -0400
Subject: Re: [PATCH 2/5] jffs2: Add LZO compression support to jffs2
From: David Woodhouse <dwmw2@infradead.org>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
In-Reply-To: <1178278255.5839.47.camel@localhost.localdomain>
References: <1178278255.5839.47.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 04 May 2007 12:35:32 +0100
Message-Id: <1178278532.11120.274.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 12:30 +0100, Richard Purdie wrote:
> +config JFFS2_LZO
> +       bool "JFFS2 LZO compression support" if JFFS2_COMPRESSION_OPTIONS
> +       select LZO 

Please make it _depend_ on LZO instead. If you do that, I can merge the
JFFS2 bits in anticipation of the core LZO code going upstream.

-- 
dwmw2

