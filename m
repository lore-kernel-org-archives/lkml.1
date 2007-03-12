Return-Path: <linux-kernel-owner+w=401wt.eu-S1161023AbXCLRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023AbXCLRM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030722AbXCLRM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:12:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:52125 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030720AbXCLRM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gnl+ggk0Q4HG3skZ5zlHDzHwxPL5taHhWKvUIS0/Ng2WD8Uje9DmV5c5KB4dUe3EGhyYg3Q82ksQcDYI7nXgLPuzNrKTsXUKKA4VHDtIqqAdxSQYzX0Hkj+uHyy9uWIFLIOW+FaON2RQgHojgMsgRyxZqvcfrDQy4KjivqIF4h8=
Message-ID: <3aac340703121012k7d2bb9cby62651079405ad8e7@mail.gmail.com>
Date: Mon, 12 Mar 2007 19:12:22 +0200
From: Vitaliyi <imgrey@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: libata extension
In-Reply-To: <3aac340703121003l43685599t8dbffe6247879a91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3aac340703102322p362998b9labedc13503702d2b@mail.gmail.com>
	 <45F56800.3040104@rtr.ca>
	 <3aac340703121003l43685599t8dbffe6247879a91@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Vitaliyi <imgrey@gmail.com>
Date: Mar 12, 2007 7:03 PM
Subject: Re: libata extension
To: Mark Lord <lkml@rtr.ca>


> Use the SCSI SG_IO ioctl() with opcode=ATA_16,
> which gives you access to the ATA Passthrough mechanism.
> This will work for most ATA commands.

How about soft-reset, is it possible to reach Device Control Register ?
Seems not. I was thinking about patch to libata which allow to use
Control Register.
In the perfect case i would like to be able to execute vendor command
set (reverse engineered).

Is it possible to control timeouts in user space precisely enough and
get rid of unnecessary kernel error messages without touching
syslogd/klogd?

By the way, how to make libata to not probe some ide channel or drive ?

> I already use it in hdparm and in some other utilities
> for scanning/repairing drives.
>
> A notable exeception are the READ/WRITE LONG opcodes,
> which require an extra kernel patch from me,
> awaiting merge into libata some year.

Could you please send me this patch once it's ready ?


Thank you
