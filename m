Return-Path: <linux-kernel-owner+w=401wt.eu-S1765720AbYBVTxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765720AbYBVTxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763492AbYBVTwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:52:43 -0500
Received: from h155.mvista.com ([63.81.120.155]:58349 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764632AbYBVTwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:52:41 -0500
Message-ID: <47BF2846.1030604@ru.mvista.com>
Date: Fri, 22 Feb 2008 22:53:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] hpt366: fix section mismatch warnings
References: <20080222194651.GA7154@uranus.ravnborg.org>
In-Reply-To: <20080222194651.GA7154@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:

> hpt366: fix section mismatch warnings

> Fix following warnings:
> WARNING: o-sparc64/vmlinux.o(.data+0x195a38): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370
> WARNING: o-sparc64/vmlinux.o(.data+0x195a40): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370a
> WARNING: o-sparc64/vmlinux.o(.data+0x195a48): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372
> WARNING: o-sparc64/vmlinux.o(.data+0x195a50): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372n

> Replace a static array with a small switch resulting in
> more readable code.
> Be consistent in use of __devinitconst for const data
> to avoid section type conflicts.
> Mark the pci table __devinitconst.

> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
