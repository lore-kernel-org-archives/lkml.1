Return-Path: <linux-kernel-owner+w=401wt.eu-S1765948AbYBVUqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765948AbYBVUqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYBVUqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:46:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:28490 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYBVUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:46:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Cu78HlxS5CPI9skEscOJ8z4NuWls2SBS+4sTbtPDIwMyS5hy98Hjojp9UWXUYfCJ396eREIWCSJV22aPWFAhC+bTJJGvYNgmfm1KUovBfqFmutYkGtJUobwB6PQFiq8/fdGFoKQN6OXVT9HQBUZqHdGELOGdmFdFtNMfpAUNlo4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] hpt366: fix section mismatch warnings
Date: Fri, 22 Feb 2008 21:57:15 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <20080222194651.GA7154@uranus.ravnborg.org> <47BF2846.1030604@ru.mvista.com>
In-Reply-To: <47BF2846.1030604@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222157.15480.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008, Sergei Shtylyov wrote:
> Sam Ravnborg wrote:
> 
> > hpt366: fix section mismatch warnings
> 
> > Fix following warnings:
> > WARNING: o-sparc64/vmlinux.o(.data+0x195a38): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370
> > WARNING: o-sparc64/vmlinux.o(.data+0x195a40): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370a
> > WARNING: o-sparc64/vmlinux.o(.data+0x195a48): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372
> > WARNING: o-sparc64/vmlinux.o(.data+0x195a50): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372n
> 
> > Replace a static array with a small switch resulting in
> > more readable code.
> > Be consistent in use of __devinitconst for const data
> > to avoid section type conflicts.
> > Mark the pci table __devinitconst.
> 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
