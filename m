Return-Path: <linux-kernel-owner+w=401wt.eu-S1763512AbYDVSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763512AbYDVSq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYDVSqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:46:10 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:62616 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbYDVSqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ROUlpu8vRm9Fo+jsdoGuMywfgI6ncKnUA+wpfpOORsYTNubhBAaC+ENLW8g6GgOb4r0BfgMXAJ5nDdaVsd8PZblGftISma5aIdX2Ssyay+kU+uLPRI/qgm5L4eqD35pSVCGa+8GrRqpxLeZcL3G2I2JUf4iInnC92UF9dDlEpcU=
Date: Tue, 22 Apr 2008 23:41:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/proc/kmsg.c should #include <linux/proc_fs.h>
Message-ID: <20080422194128.GA15859@martell.zuzino.mipt.ru>
References: <20080421213209.GN2633@cs181133002.pp.htv.fi> <20080421224314.GA963@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421224314.GA963@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 02:43:14AM +0400, Alexey Dobriyan wrote:
> On Tue, Apr 22, 2008 at 12:32:09AM +0300, Adrian Bunk wrote:
> > Every file should include the headers containing the externs its global 
> > code.
> 
> Declaration should be moved to fs/proc/internal.h and included from
> there.

I wrote basically the same in February, what's up?

http://marc.info/?l=linux-kernel&m=120324267808331&w=2

