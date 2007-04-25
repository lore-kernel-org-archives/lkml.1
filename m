Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXDYAtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXDYAtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXDYAtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:49:49 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:4197 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbXDYAts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:49:48 -0400
Date: Wed, 25 Apr 2007 02:49:46 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 1/7] libata: check for AN support
Message-ID: <20070425004946.GA63747@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, htejun@gmail.com
References: <20070424074856.005152262@intel.com> <20070423165943.0cc67bc5.kristen.c.accardi@intel.com> <20070424090713.65657495@the-village.bc.nu> <20070424102304.GA58841@dspnet.fr.eu.org> <20070424084904.61932994.kristen.c.accardi@intel.com> <20070424180552.GA17319@dspnet.fr.eu.org> <20070424135327.8fe0b0ba.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424135327.8fe0b0ba.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 01:53:27PM -0700, Kristen Carlson Accardi wrote:
> Check to see if an ATAPI device supports Asynchronous Notification.
> If so, enable it.
> 
> changes from last version: 
> * fix typo in ata_id_has_AN and make word 76 test more clear
> * If we fail to set the AN feature, just print a warning and continue
>  
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> @@ -299,6 +305,8 @@ struct ata_taskfile {
>  #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
>  #define ata_id_removeable(id)	((id)[0] & (1 << 7))
>  #define ata_id_has_dword_io(id)	((id)[50] & (1 << 0))
> +#define ata_id_has_AN(id)	\
> +	(((id[76] != 0x0000) && (id[76] != 0xffff)) && ((id)[78] & (1 << 5)))

(id)[76] I guess ?  Sorry for being a pain :/

  OG.
