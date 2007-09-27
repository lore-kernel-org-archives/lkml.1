Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbXI0Xy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbXI0Xy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbXI0XyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:54:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:29519 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760368AbXI0XyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Co9MswrhVZoq+9c9t42sqWZIzYrF/zXGDSfxg8+aom4cciH3mRDKdlGWgWRioXbxbCIdzJ6zfNBwBLtG9aPsamtRqm9KZil3xDhg+FFDI3aRwXlrGm8ibPGth3Shra08U4kBbMX68Gvn2EM1DAqeYEL1gDycn93o5PNRp4hdL3M=
Message-ID: <46FC423C.2050206@gmail.com>
Date: Thu, 27 Sep 2007 16:52:28 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com>	<20070905095327.6277d054.akpm@linux-foundation.org>	<46DEE617.4050004@rtr.ca>	<46E0A253.7060803@gmail.com>	<46E154DE.2060602@rtr.ca>	<46FB563A.80108@gmail.com> <20070927193701.6230d77f@the-village.bc.nu> <46FC3D7D.90009@gmail.com> <46FC3FDD.5060201@pobox.com>
In-Reply-To: <46FC3FDD.5060201@pobox.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Alan Cox wrote:
>>>> I think there have been enough cases where this draining was necessary.
>>>>  IIRC, ata_piix was involved in those cases, right?  If so, can you
>>>> please submit a patch which applies this only to affected controllers?
>>>> I don't feel too confident about applying this to all SFF controllers.
>>> Old IDE does it on all controllers bar a couple. So we have a very good
>>> knowledge of what does/doesn't work. The one that needs care in old ide
>>> is an ordering issue where a state machine reset done first causes the
>>> drain of the I/O to hang.
>>
>> Hmmm... So, do we apply draining to all PATA?  Or is ata_piix SATA
>> affected too?
> 
> I would think all SFF controllers, since a lot of first gen SATA are
> really bridged solutions.  If they are flagging DRQ, I say oblige them :)

Alright, then the posted patch should be good enough.  Mark, can you be
bothered to regenerate the patch and post it one more time (again)?  It
seems we all agree the update is needed.

Thanks a lot.

-- 
tejun
