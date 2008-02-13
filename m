Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbYBMTHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbYBMTHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbYBMTHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:07:34 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:51042 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYBMTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:07:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UWhmi8Ama+YVwIaw9ulDQUibmzZkTsVJp9xjPcsaHdp+Ojk46YKRyQl2fSfETOavuYAI5AV075O5QDeTUwqaE8bIDyUL8gjjLezqmt9I43gdmKkLC68vgGnqgyHstQplh9bRym5QL3BFVdo1jU0UaEHv0bWFNIwEYt9+jqEhCd8=
Message-ID: <e9c3a7c20802131107x4c9e6859p3bc6527b19c416cb@mail.gmail.com>
Date: Wed, 13 Feb 2008 12:07:26 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	 <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: 2db55569951c5312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 9:43 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
[..]
>  /**
> + * struct dma_slave_descriptor - extended DMA descriptor for slave DMA
> + * @async_tx: async transaction descriptor
> + * @client_node: for use by the client, for example when operating on
> + *     scatterlists.
> + */
> +struct dma_slave_descriptor {
> +       struct dma_async_tx_descriptor txd;
> +       struct list_head client_node;
> +};

Can you explain a bit why client_node is needed?  I do not think we
need dma_slave_descriptor if dma_unmap data / control is added to
dma_async_tx_descriptor.  Hmm?
