Return-Path: <linux-kernel-owner+w=401wt.eu-S1161427AbXBGUhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161427AbXBGUhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 15:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161425AbXBGUhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 15:37:38 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4489 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161427AbXBGUhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 15:37:36 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_acpi: take two
Date: Wed, 7 Feb 2007 21:38:02 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, jeff@garzik.org
References: <20070207172220.04c96dc5@localhost.localdomain>
In-Reply-To: <20070207172220.04c96dc5@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702072138.03167.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Just asking ... in:

> +static void *ata_pata_find_handle(struct device *dev, int port)

...

> +       chan_handle = acpi_get_child(handle, port);
> +       if (chan_handle == NULL)
> +               return NULL;
> +       return chan_handle;
> +}

why not simply:

	return acpi_get_child(hadnle, port);

?

Regards,

	Mariusz Kozlowski
