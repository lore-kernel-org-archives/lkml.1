Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZJ0Mxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZJ0Mxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 08:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZJ0Mxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 08:53:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:53364 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZJ0Mxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 08:53:36 -0400
Date: Tue, 27 Oct 2009 13:53:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: liu weni <qingshenlwy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kernel/irq/chip.c:The code notes is not fit for the
 function.
In-Reply-To: <b3657a100910260622w37cc2ab6nc0b52ce6e1a19f37@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0910271353130.25075@twin.jikos.cz>
References: <b3657a100910260622w37cc2ab6nc0b52ce6e1a19f37@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-329048593-1256648021=:25075"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-329048593-1256648021=:25075
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 26 Oct 2009, liu weni wrote:

> In the origin, the code notes are not fit for set_irq_msi.
> I modify the code notes, and no any changes for the code.
> 
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index c166019..da2f254 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -166,11 +166,11 @@ int set_irq_data(unsigned int irq, void *data)
>  EXPORT_SYMBOL(set_irq_data);
> 
>  /**
> - * set_irq_data - set irq type data for an irq
> + * set_irq_msi - set MSI descriptor data for an irq
>   * @irq: Interrupt number
>   * @entry: Pointer to MSI descriptor data
>   *
> - * Set the hardware irq controller data for an irq
> + * Set the MSI descriptor entry for an irq
>   */
>  int set_irq_msi(unsigned int irq, struct msi_desc *entry)
>  {

Please send the patch with proper Signed-off-by: line so that I can queue 
it in my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

---1747641777-329048593-1256648021=:25075--
