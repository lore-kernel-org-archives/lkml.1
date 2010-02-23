Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0BWH1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:27:31 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:32955 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0BWH13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:27:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QrfQ5FHzdCBikqSLC1Zl4+nmLsVLsgca1F7o0CVgBxQfUNepKmrCD9MYmHfjIf6Sjy
         rq46R7M+P4fhyXNu/Jx+ydymmdrz0LMZ+hXvx/hM/SNU9FjHrFStCXp8cdxW7KZcHYDg
         AFW1hAR4craNaYBdLvpOBOLnmkXKTAvFJZToI=
Message-ID: <4B83835C.8090707@garzik.org>
Date: Tue, 23 Feb 2010 02:27:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/5] libata: Pass host flags into the pci helper
References: <20100217131532.16884.21696.stgit@localhost.localdomain>
In-Reply-To: <20100217131532.16884.21696.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 08:15 AM, Alan Cox wrote:
> This allows parallel scan and the like to be set without having to stop
> using the existing full helper functions. This patch merely adds the argument
> and fixes up the callers. It doesn't undo the special cases already in the
> tree or add any new parallel callers.
>
> Signed-off-by: Alan Cox<alan@linux.intel.com>
> ---
>
>   drivers/ata/ata_generic.c       |    2 +-
>   drivers/ata/libata-sff.c        |    6 ++++--
>   drivers/ata/pata_acpi.c         |    2 +-
>   drivers/ata/pata_ali.c          |    2 +-
>   drivers/ata/pata_amd.c          |    2 +-
>   drivers/ata/pata_artop.c        |    2 +-
>   drivers/ata/pata_atiixp.c       |    2 +-
>   drivers/ata/pata_cmd640.c       |    2 +-
>   drivers/ata/pata_cmd64x.c       |    2 +-
>   drivers/ata/pata_cs5530.c       |    2 +-
>   drivers/ata/pata_cs5535.c       |    2 +-
>   drivers/ata/pata_cs5536.c       |    2 +-
>   drivers/ata/pata_cypress.c      |    2 +-
>   drivers/ata/pata_efar.c         |    2 +-
>   drivers/ata/pata_hpt366.c       |    2 +-
>   drivers/ata/pata_hpt37x.c       |    2 +-
>   drivers/ata/pata_hpt3x2n.c      |    2 +-
>   drivers/ata/pata_it8213.c       |    2 +-
>   drivers/ata/pata_it821x.c       |    2 +-
>   drivers/ata/pata_jmicron.c      |    2 +-
>   drivers/ata/pata_marvell.c      |    2 +-
>   drivers/ata/pata_netcell.c      |    2 +-
>   drivers/ata/pata_ns87410.c      |    2 +-
>   drivers/ata/pata_ns87415.c      |    2 +-
>   drivers/ata/pata_oldpiix.c      |    2 +-
>   drivers/ata/pata_opti.c         |    2 +-
>   drivers/ata/pata_optidma.c      |    2 +-
>   drivers/ata/pata_pdc202xx_old.c |    2 +-
>   drivers/ata/pata_piccolo.c      |    2 +-
>   drivers/ata/pata_radisys.c      |    2 +-
>   drivers/ata/pata_rz1000.c       |    2 +-
>   drivers/ata/pata_sc1200.c       |    2 +-
>   drivers/ata/pata_serverworks.c  |    2 +-
>   drivers/ata/pata_sil680.c       |    2 +-
>   drivers/ata/pata_sis.c          |    2 +-
>   drivers/ata/pata_sl82c105.c     |    2 +-
>   drivers/ata/pata_triflex.c      |    2 +-
>   drivers/ata/pata_via.c          |    2 +-
>   include/linux/libata.h          |    4 ++--
>   39 files changed, 43 insertions(+), 41 deletions(-)

applied (after catching one miss in drivers/staging/)


