Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZIQRLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZIQRLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZIQRLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:11:00 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50500 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbZIQRK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:10:59 -0400
X-Sasl-enc: K7A+oMLsR7QsTgvl3Cj3JJLzZGlAjqEE5rzQy4ElMz3k 1253207462
Date: Thu, 17 Sep 2009 14:10:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Len Brown <lenb@kernel.org>, linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: set acpi_driver.owner in all acpi drivers
Message-ID: <20090917171059.GA789@khazad-dum.debian.net>
References: <4AB0FDB7.1050204@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB0FDB7.1050204@tuffmail.co.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Alan Jenkins wrote:
> The owner field provides the link between drivers and modules in sysfs,
> but no ACPI driver was setting it.
> 
> After setting the owner field we can see which module provides which
> driver and vice versa by looking at /sys/bus/acpi/driver/*/module and
> /sys/module/*/drivers/acpi:*.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

For the thinkpad-acpi changes:
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
