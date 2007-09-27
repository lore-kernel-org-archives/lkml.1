Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbXI0XeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbXI0XeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759036AbXI0Xd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:33:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:20020 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652AbXI0Xd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MG5DEo3eDurEPmwmeSPmcK48AYDgegtPpX6zJ8PgI+BT65Zdgcd448O6aMh9CJ83FaobKmXSYtYSFs9YFq7vsKHP8U59p9aR4E9g5YNiP0ur2PZDHPqeb8nwhQ0ZFTZpTv9xHQjPfiRZmP5jQ2/NMrAWj8ly24Ek5GyQ+Rdcy0o=
Message-ID: <46FC3D7D.90009@gmail.com>
Date: Thu, 27 Sep 2007 16:32:13 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mark Lord <liml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com>	<20070905095327.6277d054.akpm@linux-foundation.org>	<46DEE617.4050004@rtr.ca>	<46E0A253.7060803@gmail.com>	<46E154DE.2060602@rtr.ca>	<46FB563A.80108@gmail.com> <20070927193701.6230d77f@the-village.bc.nu>
In-Reply-To: <20070927193701.6230d77f@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I think there have been enough cases where this draining was necessary.
>>  IIRC, ata_piix was involved in those cases, right?  If so, can you
>> please submit a patch which applies this only to affected controllers?
>> I don't feel too confident about applying this to all SFF controllers.
> 
> Old IDE does it on all controllers bar a couple. So we have a very good
> knowledge of what does/doesn't work. The one that needs care in old ide
> is an ordering issue where a state machine reset done first causes the
> drain of the I/O to hang.

Hmmm... So, do we apply draining to all PATA?  Or is ata_piix SATA
affected too?

-- 
tejun
