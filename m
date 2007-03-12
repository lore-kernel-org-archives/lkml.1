Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbXCLUdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbXCLUdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXCLUdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:33:23 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:47632 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXCLUdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eppNXtir/G6TMWb6dJ333rMDcibx40597TzQ8SGEcnZ/to9/GU1kO326+IRxCMNiKyVn7KHdiGXnJ9zUPl8wXSSRI8PtPiATe+Qle3rq+s+dANc9IrdLCuW5nNEsG0O48qxQsqD2WVSTYHux75uj23sjO52udGw30UPmUTwXCmc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
Date: Mon, 12 Mar 2007 21:40:25 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070312085447.GA10955@janus> <200703121321.18299.bzolnier@gmail.com> <20070312124007.GB12265@janus>
In-Reply-To: <20070312124007.GB12265@janus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703122140.25682.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 12 March 2007, Frank van Maarseveen wrote:
> On Mon, Mar 12, 2007 at 01:21:18PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > Could you check if this is the same problem as this one:
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8169
> 
> Looks like it except that I don't see "lost interrupt" messages here. So,
> it might be something different (I don't know).

>From the first mail:

hda: max request size: 128KiB
hda: 40021632 sectors (20491 MB) w/2048KiB Cache, CHS=39704/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda4

It seems that DMA is not used by default (CONFIG_IDEDMA_PCI_AUTO=n),
so this is probably exactly the same issue.

Please try the patch attached to the bugzilla bug entry.

Thanks,
Bart
