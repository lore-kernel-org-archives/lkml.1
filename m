Return-Path: <linux-kernel-owner+w=401wt.eu-S1761556AbXHEUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbXHEUSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXHEUSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:18:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42385 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019AbXHEUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:18:06 -0400
X-Sasl-enc: TdIvp4a+CgtJouth/Ul7I2C5ISFZkPjzC2hlCkELYPmv 1186345084
Date: Sun, 5 Aug 2007 17:18:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adrian Bunk <bunk@stusta.de>
Cc: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       ibm-acpi-devel@lists.sourceforge.net,
       =?iso-8859-1?Q?Ren=E9?= Treffer <treffer@in.tum.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2.6.23 regression fix] fix thinkpad_acpi without hardware
Message-ID: <20070805201801.GB16723@khazad-dum.debian.net>
References: <20070805195354.GF3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070805195354.GF3972@stusta.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Aug 2007, Adrian Bunk wrote:
> René Treffer reported that booting a CONFIG_THINKPAD_ACPI=y kernel on a 
> machine without the hardware results in an Oops.
> 
> The trace is thinkpad_acpi_module_init -> thinkpad_acpi_module_exit -> 
> driver_remove_file -> sysfs_hash_and_remove.
> 
> The error handling if thinkpad_acpi_module_init() fails generally looks 
> suspicious, but this patch at least fixes the common case if no hardware 
> was found, and it seems in this case there isn't any cleanup 
> actually required.
> 
> Broken by commit d5a2f2f1d68e2da538ac28540cddd9ccc733b001.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

NAK

Proper fix already sent to Len Brown, and already queued to be pulled by
Linus.

Len, that'd be "ACPI: thinkpad-acpi: fix the module init failure path",
http://thread.gmane.org/gmane.linux.acpi.devel/24413

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
