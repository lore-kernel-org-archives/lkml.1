Return-Path: <linux-kernel-owner+w=401wt.eu-S1761856AbXIZO1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856AbXIZO1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760046AbXIZOXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:23:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:12391 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760456AbXIZOWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TjzQoq0bhqwkVYD2ytNKhvx68qaMEkYuEqoySR3uIwx8cfYX9cITVJUIV0vYZA6vx6khWet61DW2xa/sD3VeQhrRAw+yYNHf0NIJrndD6RlAsAedHEgfhHx3uqKD6PEob1pZMnd7MxMQ6VTYgvGBctajb6Uw+P7mKFRF6DRiPWc=
Message-ID: <46FA6B29.3030807@gmail.com>
Date: Wed, 26 Sep 2007 08:22:33 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Bernd Schmidt <bernds_cb1@t-online.de>
CC: Jeff Garzik <jeff@garzik.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F9E2CB.9000002@garzik.org> <46FA2E84.90708@t-online.de>
In-Reply-To: <46FA2E84.90708@t-online.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt wrote:
> One of these appears in my system as well (ASUS P5W-DH Deluxe
> mainboard).  Here's the hdparm output:

Yup, same mainboard here.

> Since about 2.6.17 or 2.6.18, it has been causing long delays while
> booting:
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> ata2: port is slow to respond, please be patient (Status 0x80)
> ata2: COMRESET failed (errno=-16)
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
> ata2.00: 640 sectors, multi 1: LBA
> ata2.00: configured for UDMA/133

And yup, same problem with the painful boot delays since 2.6.18.  Tejun
indicated that a fix would get merged with 2.6.23, but that didn't
happen.  Here's hoping something makes it into .24!

Berck
