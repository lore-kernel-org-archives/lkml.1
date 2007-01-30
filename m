Return-Path: <linux-kernel-owner+w=401wt.eu-S965376AbXA3Nty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376AbXA3Nty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965405AbXA3Nty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:49:54 -0500
Received: from mail.suse.de ([195.135.220.2]:33836 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965376AbXA3Ntx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:49:53 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] VIA IRQ quirk breakage fix
Date: Tue, 30 Jan 2007 14:49:51 +0100
User-Agent: KMail/1.9.1
Cc: Sergey Vlasov <vsu@altlinux.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
References: <45B6A94A.3010006@yahoo.com.au> <200701301325.58843.jdelvare@suse.de> <45BF4A3A.2040001@yahoo.com.au>
In-Reply-To: <45BF4A3A.2040001@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701301449.52147.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Le Mardi 30 Janvier 2007 14:38, Nick Piggin a écrit :
> Jean Delvare wrote:
> > Yes, this sounds like the right thing to do. So here comes the third
> > (and hopefully last) iteration of the patch:
>
> Thanks Jean, this patch works fine for me.

Great, thanks for testing.

> Is this 2.6.20 material? Might it cause more regressions than it fixes?

I do believe this is 2.6.20 material. Given that Alan's version doesn't work 
_at all_, my patch can only help. The real regression is between 2.6.19 and 
the current Linus tree (with Alan's quirk.)

> Andrew, can you pick up this patch in place of the old one you got
> (fix-via-irq-quirk-breakage.patch). It was sent to lkml just now.

Yes, please. And possibly send it over to Linus while you're there, if 
everyone's happy with this version.

Thanks,
-- 
Jean Delvare
Suse L3
