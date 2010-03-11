Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0CKSdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:33:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:24997 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab0CKSda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:33:30 -0500
Message-ID: <4B9936F2.3020105@ru.mvista.com>
Date: Thu, 11 Mar 2010 21:31:14 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH 21/37] drivers/ata: use .dev.of_node instead of .node
 in	struct of_device
References: <20100311174830.4824.19820.stgit@angua> <20100311180543.4824.70491.stgit@angua>
In-Reply-To: <20100311180543.4824.70491.stgit@angua>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Grant Likely wrote:

> .node is being removed
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>
>  drivers/ata/pata_macio.c       |    2 +-
>  drivers/ata/pata_of_platform.c |    2 +-
>  drivers/ide/pmac.c             |   10 +++++-----
>  3 files changed, 7 insertions(+), 7 deletions(-)
>   

   Should probably have been 2 patches instead of one, as drivers/ata/ 
and drivers/ide/ are different subsystems...

MBR, Sergei

