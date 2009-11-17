Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZKQDRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZKQDRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 22:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZKQDRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 22:17:44 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50930 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZKQDRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 22:17:44 -0500
Message-ID: <4B0215DB.2010301@pobox.com>
Date: Mon, 16 Nov 2009 22:17:47 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -2nd repost 1/1] ATA: pata_via, fix double put on isa
 bridge
References: <1257351063-5616-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1257351063-5616-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 11:11 AM, Jiri Slaby wrote:
> In via_init_one, when via_isa_bridges iterator reaches
> PCI_DEVICE_ID_VIA_ANON and last but one via_isa_bridges bridge is
> found but rev doesn't match, pci_dev_put(isa) is called twice.
>
> Do pci_dev_put only once.
>
> Signed-off-by: Jiri Slaby<jirislaby@gmail.com>
> Cc: Jeff Garzik<jgarzik@pobox.com>
> ---
>   drivers/ata/pata_via.c |   10 ++++------
>   1 files changed, 4 insertions(+), 6 deletions(-)

applied


