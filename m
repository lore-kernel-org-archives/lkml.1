Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZKYOzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZKYOzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZKYOzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:55:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:44884 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZKYOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PFYGCIekfL4iBGa8FAe6MtkiTqbf/6jxU+QXvgcpUoeIXBBMUrSF4EBj1pLcme/zfS
         Ofjnw4yfp+Fz3LX4R/+zD/nhHkx2ut3nHoZyy+FrGDl9KjN70HYk6vVM8QtFL9F2GJRQ
         eh6atzgoMcfcZzeUfJAz0PgZWyAzGi8FVSf5Q=
Subject: Re: The work of ricoh_mmc isn't detected by pci core
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, philipl@alumni.utexas.net
In-Reply-To: <20091123162119.3777e14d@fido2.homeip.net>
References: <1259021583.16650.9.camel@maxim-laptop>
	 <20091123162119.3777e14d@fido2.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 16:55:47 +0200
Message-ID: <1259160947.10147.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I converted your driver input pci quirk, and this works very well.
MMC device disappears without any trace.
Suspend/resume works fine.

07:00.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 05)
07:00.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
07:00.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
07:00.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)


Best regards,
	Maxim Levitsky

