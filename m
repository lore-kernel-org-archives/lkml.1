Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZBZKbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZBZKbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZBZKb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:31:29 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:35101 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZBZKb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:31:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w1XIsjxng5f3q+QVz7lCIva5lx9lhSDOCpHyktKctfae7/tOgGhosz5XbEKoXcGmfZ
         QR8WpjNwVOh73sMbCzAZk2Kt5TJmzCUIcsoRMJj1opkU7WsuTi01eHCC0sYriqmP2ClQ
         JhZzmJzhp0OcJ/fbWmvMOItY6WoZapEliTdUA=
MIME-Version: 1.0
In-Reply-To: <20090226100327.3615.21419.stgit@linux.site>
References: <20090226100327.3615.21419.stgit@linux.site>
Date: Thu, 26 Feb 2009 02:31:24 -0800
X-Google-Sender-Auth: 9085770c34b7a57d
Message-ID: <9929d2390902260231p72aacdf3j489a8a9e67dbb659@mail.gmail.com>
Subject: Re: [PATCH 0/7] I/OAT update
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: dan.j.williams@intel.com, snakebyte@gmx.de, shannon.nelson@intel.com,
       jeffrey.t.krisher@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 2:04 AM, Maciej Sosnowski
<maciej.sosnowski@intel.com> wrote:
> This patch series updates ioatdma driver
> with a couple of fixes and workarounds,
> including copybreak modification,
> plus some cleanup like copyright dates update.
>
> Maciej Sosnowski (6):
>    I/OAT: add verification for proper APICID_TAG_MAP setting by BIOS
>    I/OAT: do not set DCACTRL_CMPL_WRITE_ENABLE for I/OAT ver.3
>    I/OAT: fail initialization on zero channels detection
>    I/OAT: cancel watchdog before dma remove
>    I/OAT: set tcp_dma_copybreak to 256k for I/OAT ver.3
>    I/OAT: update driver version and copyright dates
>
> Eric Sesterhenn (1):
>    I/OAT: list usage cleanup
>
>  drivers/dca/dca-core.c          |    2 -
>  drivers/dma/ioat.c              |    2 -
>  drivers/dma/ioat_dca.c          |   26 ++++++++++++++++++++++++-
>  drivers/dma/ioat_dma.c          |   31 ++++++++++++++++++------------
>  drivers/dma/ioatdma.h           |    8 ++++---
>  drivers/dma/ioatdma_hw.h        |    2 -
>  drivers/dma/ioatdma_registers.h |    2 -
>  7 files changed, 53 insertions(+), 20 deletions(-)
>
> --
> Maciej
> --
>

Dave - FYI, my Acked-by email on this patch series is incorrect.  It
should be jeffrey.t.kirsher@intel.com not "krisher".

-- 
Cheers,
Jeff
