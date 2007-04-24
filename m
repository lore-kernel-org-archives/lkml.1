Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXDXKXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXDXKXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXDXKXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:23:08 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3201 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbXDXKXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:23:07 -0400
Date: Tue, 24 Apr 2007 12:23:04 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 1/7] libata: check for AN support
Message-ID: <20070424102304.GA58841@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, htejun@gmail.com
References: <20070424074856.005152262@intel.com> <20070423165943.0cc67bc5.kristen.c.accardi@intel.com> <20070424090713.65657495@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424090713.65657495@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for replying to Alan's reply, I missed the original mail.

> > +#define ata_id_has_AN(id)	\
> > +	((id[76] && (~id[76])) & ((id)[78] & (1 << 5)))

(a && ~a) & (b & 32)

I don't think that does what you think it does, because at that point
it's a funny way to write 0 ((0 or 1) binary-and (0 or 32)).

I'm not even sure what it is you want.  If for the first part you
wanted (id[76] != 0x00 && id[76] != 0xff), please write just that,
thanks :-)

  OG.
