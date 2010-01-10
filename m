Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376Ab0AJQI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0AJQI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834Ab0AJQI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:08:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56484 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0AJQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:08:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B49FB63.8050700@s5r6.in-berlin.de>
Date: Sun, 10 Jan 2010 17:08:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: linux1394-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: Re: [PATCH] firewire: make PCI device id constant
References: <4B49C4A2.50804@freemail.hu>
In-Reply-To: <4B49C4A2.50804@freemail.hu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> The id_table field of the struct pci_driver is constant in <linux/pci.h>
> so it is worth to make pci_table also constant.
[...]
> --- a/drivers/firewire/ohci.c 2010-01-07 19:08:39.000000000 +0100
> +++ b/drivers/firewire/ohci.c 2010-01-08 09:51:11.000000000 +0100
> @@ -2657,7 +2657,7 @@ static int pci_resume(struct pci_dev *de
>  }
>  #endif
> 
> -static struct pci_device_id pci_table[] = {
> +static const struct pci_device_id pci_table[] = {
>  	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_FIREWIRE_OHCI, ~0) },
>  	{ }
>  };

Committed to linux1394-2.6.git with an adequately shortened changelog.
-- 
Stefan Richter
-=====-==-=- ---= -=-=-
http://arcgraph.de/sr/
