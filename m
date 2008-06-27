Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYF0GKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYF0GKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYF0GJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:09:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41248 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862AbYF0GJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:09:56 -0400
Message-ID: <48648427.8000606@pobox.com>
Date: Fri, 27 Jun 2008 02:09:43 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       David Newall <davidn@davidnewall.com>, netdev@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 8139too: some style cleanups
References: <4853BB62.1060109@freemail.hu> <4853C8AD.9020407@s5r6.in-berlin.de> <48541165.7050304@freemail.hu> <485421C1.8010102@s5r6.in-berlin.de> <4854C9BF.8040900@freemail.hu> <4854CA3E.60208@freemail.hu>
In-Reply-To: <4854CA3E.60208@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.4 (---)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-3.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Clean up the following errors and warnings reported by checkpatch.pl:
>  + ERROR: Macros with complex values should be enclosed in parenthesis
>  + WARNING: __func__ should be used instead of gcc specific __FUNCTION__
>  + WARNING: plain inline is preferred over __inline__
>  + WARNING: Use #include <linux/io.h> instead of <asm/io.h>
>  + WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> 
> The changes were verified with by comparing the "objdump -d 8139too.ko"
> output which is exactly the same for the old and new version in case of
> config CONFIG_8139TOO=m, CONFIG_8139TOO_PIO=n, CONFIG_8139TOO_TUNE_TWISTER=n,
> CONFIG_8139TOO_8129=n, CONFIG_8139_OLD_RX_RESET=n.
> Software versions used: gcc 4.2.3, objdump 2.18.0.20080103, on elf32-i386.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

applied, thanks for whittling down the changes to this set


