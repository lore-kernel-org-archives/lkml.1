Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYKIUvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYKIUvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYKIUvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:51:32 -0500
Received: from isilmar.linta.de ([213.133.102.198]:35426 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755675AbYKIUvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:51:31 -0500
Date: Sun, 9 Nov 2008 21:43:41 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: minor logging improvement on card detection
Message-ID: <20081109204341.GA16869@comet.dominikbrodowski.net>
Mail-Followup-To: Frans Pop <elendil@planet.nl>,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <200811031942.20360.elendil@planet.nl> <200811071419.11050.elendil@planet.nl> <200811071435.15934.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811071435.15934.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 07, 2008 at 02:35:15PM +0100, Frans Pop wrote:
> From: Frans Pop <elendil@planet.nl>
> 
> pcmcia: minor logging improvement on card detection
>     
> Show for which device a card has been inserted, so instead of:
>    pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
> print:
>    yenta_cardbus 0000:01:0b.0: pccard: CardBus card inserted into slot 0
>     
> This provides a more logical link between previous and following messages.

unfortunately, this won't work -- &skt->cb_dev is only available and set if
the parent device is a PCI device; therefore, &skt->dev is the only thing we
can use.

Best,
	Dominik
