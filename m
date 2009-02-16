Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZBPWRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZBPWRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZBPWQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:16:52 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:14256 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZBPWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:16:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hBO1o9hhkxp1CbGmptoSKUqhZmEn80sz+jzOwjZVfTgzAEm8nToGpKzvAutFzxX1VD
         wnIQqI5vwIDbqTpJWtGu0LVztGCxb1n/El8A6o2vOaqiqqup5VGbkZ3y3so8r8RhvLx8
         cULrtLb0irGcUmDPE1zs/Pz+ZzjGU0exPwIhs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/10] ide: flags query macros
Date: Mon, 16 Feb 2009 23:17:31 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-next-20090213; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162317.32188.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Borislav Petkov wrote:
> Hi,
> 
> this series adds the drive->atapi_flags and drive->dev_flags macro wrappers
> we discussed. The idea was to make the code more readable and this has

Fine...

> been my main concern when coming up with the macro naming, therefore
> some macro names appear a tad more descriptive than the flag itself.

...but this part destroys consistency in the process.

If you think that some flag names should be fixed please just fix them
(or just leave them alone -- I think that people invest far too much time
into fixing all these minor things while tend to fix themselves when the
big things are being fixed).

Also ide_drv_ is bad name for ->{dev,atapi}_flags (drv == "driver" for
most people not "drive") -- please make it either ide_dev_ or ide_dflag_.

Thanks,
Bart
