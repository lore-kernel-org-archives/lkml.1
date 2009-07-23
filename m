Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZGWRNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZGWRNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZGWRNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:13:34 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:62350 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZGWRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PA1nZGRqTb6wi9JENfx8AZS0lX5ZImge0XZ8MyWEHD1loOppIrWX7ObDLN6y4mc/Hr
         MCrTGsCkKr4MsAmCehvHHXd7JVYIkcqGs85Qn3739AV2QWyCpP9Ye53iVDM14MzzZ5Fm
         v37CUOO3EIuFZuYH6B85sWkNPQN8ZPH9z3zv8=
MIME-Version: 1.0
In-Reply-To: <1248285885-1189-1-git-send-email-nicolas.ferre@atmel.com>
References: <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com>
	 <1248285885-1189-1-git-send-email-nicolas.ferre@atmel.com>
Date: Thu, 23 Jul 2009 10:13:31 -0700
X-Google-Sender-Auth: bfe65d842fdaef5f
Message-ID: <e9c3a7c20907231013k3d5e8c89w1069e8509539438f@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: maciej.sosnowski@intel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:04 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
> This patch for at_hdmac adds the slave transfers capability to the Atmel DMA
> controller available on some AT91 SOCs. This allow peripheral to memory and
> memory to peripheral transfers with hardware handshaking.
>
> Slave structure for controller specific information is passed through channel
> private data. This at_dma_slave structure is defined in at_hdmac.h header file
> and relative hardware definition are moved to this file from at_hdmac_regs.h.
> Doing this we allow the channel configuration from platform definition code.
>
> This work is intensively based on dw_dmac and several slave implementations.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

Seems straightforward and self contained, applied.  Just curious which
drivers will take advantage of this slave capability?  As it stands I
do not see any in-tree users of at_hdmac beyond dmatest?

Thanks,
Dan
