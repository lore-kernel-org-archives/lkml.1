Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZENTrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZENTrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbZENTq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:46:57 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:62381 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbZENTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:46:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jBEwGcrEH/DJStd1wJUI2sfBOHPfxa7aOTqXYNHb5oPv+4a+aAjUap8qwInCq5Bgoe
         Ed/y7sz7BzkjnjIxi4AmdXqND0GFfW8d3lOWtmbqcUC6v+t+zb43cO/wwRuI/zoLvNw+
         xK57PkYwEIoFAqg6q+3CJpaX/iGj23tdA9Zpo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 6/7] ide: pass number of ports to ide_host_{alloc,add}()
Date: Thu, 14 May 2009 21:51:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain> <20090513205222.28638.19386.sendpatchset@localhost.localdomain> <4A0C6A27.7010703@ru.mvista.com>
In-Reply-To: <4A0C6A27.7010703@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905142151.15854.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009 20:59:51 Sergei Shtylyov wrote:

> > @@ -467,7 +467,7 @@ icside_register_v6(struct icside_state *
> >  	struct ide_host *host;
> >  	unsigned int sel = 0;
> >  	int ret;
> > -	hw_regs_t hw[2], *hws[] = { &hw[0], NULL, NULL, NULL };
> > +	hw_regs_t hw[2], *hws[] = { &hw[0], NULL };
> 
>     I wonder if there's an old bug here since I'm not seeing when hws[1] is 
> set to non-NULL -- despite there are apparently two ports?
> 
>     Indeed, this bug seems to date back to the 'struct ide_host' 
> introduction, see this:
>  
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=48c3c1072651922ed153bcf0a33ea82cf20df390#patch1...

Care to send a fix?
