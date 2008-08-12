Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYHLNht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYHLNht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYHLNhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:37:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:16878 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYHLNhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=knm6RlbSnHjoJcZuWy89HIaLqCg74xJJSFUNDu/cHys9bcwQlubhZf1miuM1oeVgFX
         OFoKVUS2p8fL6uBmomX9XnKDorNG1UvZ6YT3u3/rr4TF30nyangmOkMmTpmzLaX49BM6
         dE6mwxq8z4eIUA7BqLaa2h0ag1R4Te2CY7Z4I=
Message-ID: <9ea470500808120637w354b3ae0w3ceca791344bd7cc@mail.gmail.com>
Date: Tue, 12 Aug 2008 15:37:37 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH 11/22] ide: add ide_set_media_lock() helper
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200808121105.49645.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
	 <20080810153645.16255.80542.sendpatchset@localhost.localdomain>
	 <20080811060232.GA15436@gollum.tnic>
	 <200808121105.49645.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Are we switching to SCSI opcodes? What about the generic packet commands in
>> <include/linux/cdrom.h>?
>
> I prefer to use them when possible but there is no strict policy.
>
> [ SCSI defines are shorter, one of the drivers was using them already
>  and it also makes easier for comparing code with SCSI. ]

I still think we should stick to one format or the other. All
the drivers' functions, for example, comply with a naming scheme
(ide_cd/ide_floppy/...) so opcodes shouldn't be an exception, imho...

-- 
Regards/Gruss,
Boris
