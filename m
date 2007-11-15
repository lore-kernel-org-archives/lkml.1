Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbXKOEIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbXKOEIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbXKOEIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:08:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:55608 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbXKOEII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HpI+qHTMGYbq47G6NgxBosBlVkYnQCvfrpfZZ46xEqirrkFcq4Q/0yguYjCrHO7PPk6XUC8dAxIXRsSZXkWK7opWAl3cWDC6nz2W8ddmHAGxO6OyZGCVLnmla1+Umj+yqQzNaCL6RAhUc1iCxGbj14SVwJX6U3cHHiTOw+618KQ=
Message-ID: <473BC620.9020204@gmail.com>
Date: Thu, 15 Nov 2007 13:08:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata_sg_setup_one vs ata_sg_setup?
References: <200711141540.58658.rusty@rustcorp.com.au>
In-Reply-To: <200711141540.58658.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Hi Jeff,
> 
>     Was looking through libata, and it seems to me that ata_sg_setup is a
> superset of ata_sg_setup_one.  Am I missing something?  Seems like it could
> be simplified.
> 
> My machine never seems to do an ata_sg_setup_one, so this patch isn't really
> tested...

I have about the same patch queued here which also kills
ata_sg_init_one() completely and replaces
ATA_QCFLAG_SG/ATA_QCFLAG_SINGLE with ATA_QCFLAG_DMAMAP (now a single
flag).  I'll compare your version and mine and see if mine is missing
something.

Thanks.

-- 
tejun
