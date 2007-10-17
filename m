Return-Path: <linux-kernel-owner+w=401wt.eu-S936627AbXJQCsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936627AbXJQCsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761536AbXJQCr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:47:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:17273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936407AbXJQCry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ILv0QnBxg1fxdnIF3vcgJwjhb7OEmxV7NRxMw1GaxZmzKMziupbB1jNa/+uOFyaxNa8hU66/3kTQgZFVus2jKOIN3+YNiHvt0b3oRdTz2tFNzwqzu4swur8nCP9qbMFj2T1JW5c3Hhc75HJ/vkW0SrM7KcpIlvpYu+gQuI2eYZs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: hda-intel: no soundcard with current linus' git tree
Date: Wed, 17 Oct 2007 04:47:21 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <471538C2.80806@m3y3r.de>
In-Reply-To: <471538C2.80806@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710170447.21556.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2007 00:18:42 Thomas Meyer wrote:
> $ dmesg
> 
> [schnipp]
> 
> ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
> PCI: Enabling bus mastering for device 0000:00:1b.0
> PCI: Setting latency timer of device 0000:00:1b.0 to 64
> hda_codec: STAC922x, Apple subsys_id=106b0200
> ACPI: PCI interrupt for device 0000:00:1b.0 disabled
> HDA Intel: probe of 0000:00:1b.0 failed with error -16
> 
> [schnipp]
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Please bisect this (the alsa merge happened just short time ago)
Which kernel did work?

Best regards,
	Maxim Levitsky
