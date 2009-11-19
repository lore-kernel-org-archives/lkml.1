Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZKSTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZKSTzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZKSTzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:55:42 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58466 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbZKSTzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=nWYazk2GACQqL/09yntbMNN3MIrmgm0kZAofyYRbZO3qUHeV7qgFRyQHCqoAwGp4iH
         lFuHKuhKRFR3EwXfPYMCM7w/s/PhpIoQ7iVI+5EETjPdQu8p/KzQXNklPXeGiOf1Xgbu
         /aPy/Ey3AgvwtYGsVGiV2eDKJOQlQZGzCUA5M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 20:54:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911192031.31613.bzolnier@gmail.com> <20091119194213.7f4dd425@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119194213.7f4dd425@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911192054.32533.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 20:42:13 Alan Cox wrote:
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > In comparison to original patch the conversion from PCI access to
> > io has been dropped as it is not required for the bugfix and makes
> > patch easier for back-porting into -stable kernels.
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 
> (and from what Sergey says about the 371N then the I/O conversion
> is probably not needed anyway)

Thanks, I'll re-sync other pata_hpt37x patches on top of this one later.

ps if you could also push the fix to hpt366.c it would be great

-- 
Bartlomiej Zolnierkiewicz
