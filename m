Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYGOHRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYGOHRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYGOHRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:17:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:8155 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYGOHRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Kd9C2LnSKPdz9tuWZpSmoeIAj93ha/QUjzOjBPj65CiCnHCQF4OHax86yS60PY4hWm
         NcYHWYueIlOyhj27XteVe0A2NcPnj84PCM7bYLOdopdwD2Su5027023+sCPMPy6BuGnk
         ViCghyzBkEH8Azw4RQw+7gZ390zLIFln1VZE4=
Message-ID: <b170af450807150017u248d4255i3800c10cb11df319@mail.gmail.com>
Date: Tue, 15 Jul 2008 09:17:17 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: Toshiba - Documentation for Linux Developers
Cc: "Greg KH" <greg@kroah.com>, linux-acpi@vger.kernel.org, pavel@suse.cz,
       linux-kernel@vger.kernel.org
In-Reply-To: <487A1534.3000307@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <4855971D.90004@diamondcut.com.br> <20080616221443.GA760@kroah.com>
	 <b170af450807130654m2f800b10ybcba4b2c5c7cf329@mail.gmail.com>
	 <487A1534.3000307@diamondcut.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6F7Hefq018944

2008/7/13, Renato S. Yamane <yamane@diamondcut.com.br>:> RafaÅ‚ MiÅ‚ecki wrote:> > I have Toshiba A100 with Phoenix BIOS. This means toshiba_acpi doesn't>  > work for me and I can change LCD brightness.>> Rafal, try use omnibook driver.>  Get it with subversion:>  $ svn co>  https://omnibook.svn.sourceforge.net/svnroot/omnibook/omnibook/trunk>>  Use "make install" and "make load".>>  After this, maybe is possible change brightness writing in>  /proc/omnibook/lcd (0 is minimun and 7 is max brightness)
The newest version is packed for openSUSE fortunately. But it doesn'tfor my notebook. dmesg is:
omnibook: Driver version 2.20070211-trunk.omnibook: Unknown model.omnibook: dmi feature has no backend table, io_op not initialized.omnibook: version feature has no backend table, io_op not initialized.omnibook: Enabled features: dmi version.
So everything I can do istoshiba:/proc/omnibook # cat dmiBIOS Vendor:   Phoenix Technologies LTDBIOS Version:  2.00BIOS Release:  08/30/2006System Vendor: TOSHIBAProduct Name:  SATELLITE A100Version:       PSAA9E-0R101VPLSerial Number: X6623092GBoard Vendor:  Intel CorporationBoard Name:    Not Applicable
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
