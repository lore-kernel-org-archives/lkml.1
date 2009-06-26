Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbZFZThA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbZFZThA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758465AbZFZTgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:36:53 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45629 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbZFZTgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=tqTyzyl1JWDx2EcJEZARY/PtB/X/C2mHTXd8I5virDnhfIc6qUtNqw5yfnONYDROSe
         6va4QI41+qghhGB/JMvV6Mvbnn1DhPatW3eEAoY3zsFtqpSHjJ4I62PEBW/6smVcUj8S
         LYDydxmf33wTtZDOQ+8wAEBGmVy+DYHgZZyf8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] IDE: ide-taskfile.c fix compilation warning and cleanup
Date: Fri, 26 Jun 2009 21:42:42 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090617-09943-g5d77a4c; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
References: <1245650973.30547.3.camel@ht.satnam> <200906221250.36318.bzolnier@gmail.com> <1245986290.3568.1.camel@hpdv5.satnam>
In-Reply-To: <1245986290.3568.1.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906262142.43102.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 June 2009 05:18:10 Jaswinder Singh Rajput wrote:
> On Mon, 2009-06-22 at 12:50 +0200, Bartlomiej Zolnierkiewicz wrote:

> > Besides I would suggest splitting the patch on fix and cleanup parts.
> 
> Here is the cleanup part:
> 
> [PATCH] IDE: ide-taskfile.c fix style problems
> 
> Fix trivial style problems:
> 
> WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> WARNING: space prohibited between function name and open parenthesis '('
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> ERROR: do not use C99 // comments X 2
> ERROR: trailing statements should be on next line
> ERROR: trailing whitespace
> ERROR: switch and case should be at the same indent
> WARNING: line over 80 characters
> 
> total: 5 errors, 4 warnings
> 
> Also removed dead code
> 
> Also used pr_err() to avoid line breaks
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
