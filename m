Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbXCWSVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbXCWSVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXCWSVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:21:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:57815 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbXCWSVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=H97bq6CeH/mqNcM1An/4I1TE8ahwX7uSQtqSzegmnFTGcKXITsL+HYzYwzskk4+pkBWs0slYG5/XlraaPprxRWvI+9lIohcXlgD4OLc61zA5nTujsBaCFmJkoeTbZjB56/+v+b6EtPzOy/Qxm67nFauX0o28ASB9fuZ0GzXgkl4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Subject: Re: request_queue_t depends on CONFIG_BLOCK
Date: Fri, 23 Mar 2007 19:29:19 +0100
User-Agent: KMail/1.9.6
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070322215234.GA13219@aepfle.de> <20070322215351.GA7216@infradead.org> <20070323001002.GA14583@aepfle.de>
In-Reply-To: <20070323001002.GA14583@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703231929.19406.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 23 March 2007, Olaf Hering wrote:
> On Thu, Mar 22, Christoph Hellwig wrote:
> 
> > On Thu, Mar 22, 2007 at 10:52:34PM +0100, Olaf Hering wrote:
> > > How can this compile error be fixed properly?
> > > request_queue_t is inside CONFIG_BLOCK,
> > > ide_drive_s (and likely others) use it unconditionally.
> > > 
> > > 
> > >   CC      arch/powerpc/kernel/setup_64.o
> > > In file included from linux-2.6.21-rc4/arch/powerpc/kernel/setup_64.c:23:
> > 
> > start looking for the problem here.  Why does you arch code include ide.h?
> 
> Because it is needed in a few places.

Is there really any PPC64 specific code which needs <linux/ide.h>
(ppc_ide_md is used only by PPC32)?

> Better hide everything in ide.h inside #ifdef CONFIG_IDE

<linux/ide.h> is _stricly_ for IDE subsystem, please fix PPC64 code instead

Thanks,
Bart
