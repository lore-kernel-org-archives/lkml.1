Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbZKMWSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbZKMWSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZKMWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:18:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:14235 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbZKMWSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=GlVcxLlaWisRNQIBlS0GBmRx+AOqEDFxbv+LosLHTWmnB45W94mQ1aiymQyGXdyQn7
         GezXbpKrCVzKRMjPUNMgtqDBENgK3u3VQQV6ixYgyr8jBV2kag6ubY7Xgee6Kwy+55YB
         YTRBLTO84mI6L3TGafvYS7bBrJmG42gHLrq1M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Fri, 13 Nov 2009 23:17:35 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
References: <4AFCC0D4.9020708@gmail.com> <200911132039.06929.bzolnier@gmail.com> <20091113213007.774e75e3@lxorguk.ukuu.org.uk>
In-Reply-To: <20091113213007.774e75e3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911132317.35088.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009 22:30:07 Alan Cox wrote:

> > > > PATA_CMD64X: EXPERIMENTAL
> > > > - potential data corruption issues remains unfixed for CMD64[3,6]
> > > 
> > > Patch in testing, and unlike the old IDE one it doesn't cripple the
> > > controller but implements the proper workaround in full including
> > > permitting parallel PIO command streams. I'll push that back through
> > > stable once done.
> > 
> > This patch is way too complex and risky for -rc, let alone -stable.
> 
> How would you know - I've not posted it yet ? And btw I don't plan to

I prefer to not talk about "virtual" patches (especially since I'm still
waiting for HPA fixes promised in May) and the only patch so far was the one
from two weeks ago:

	http://article.gmane.org/gmane.linux.ide/43136

[ it has still unfixed problems.. ]

-- 
Bartlomiej Zolnierkiewicz
