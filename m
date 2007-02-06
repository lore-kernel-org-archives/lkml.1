Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbXBFNl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbXBFNl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXBFNl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:41:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:7937 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXBFNl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SGB81lnyw9V+x+l/T7mLparvl6fuLlWqQrol05KhifwJzNDRh/M1pzF8mSh6XF7hje5brZgQKLLw8IdW+7HM9bYNQ505qftSpUibaRSBKINYzQwkA4zLAVp6NYi1cGMgCPUt7+6m5ZcbJBWbL1Cgpdq7QOmF+Uega4hp9RW/2fE=
Message-ID: <b6fcc0a0702060541s4f14f439xe448574ba7e318a5@mail.gmail.com>
Date: Tue, 6 Feb 2007 16:41:24 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_acpi driver
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org
In-Reply-To: <20070206134623.0dc3f566@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070206134623.0dc3f566@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> An ACPI[1] firmware driver for motherboard PATA ports.

> +int ata_acpi_stm(const struct ata_port *ap, void *handle, struct acpi_gtm
> *stm)
> +{
> +	acpi_status status;
> +	struct acpi_object_list         input;
> +	union acpi_object               in_params[3];
> +
> +	in_params[0].type = ACPI_TYPE_BUFFER;
> +	in_params[0].buffer.length = sizeof(struct acpi_gtm);
> +	in_params[0].buffer.pointer = (u8 *)stm;
> +	/* Buffers for id may need byteswapping ? */
> +	in_params[1].type = ACPI_TYPE_BUFFER;
> +	in_params[1].buffer.length = 512;
> +	in_params[1].buffer.pointer = (u8 *)ap->device[0].id;
> +	in_params[2].type = ACPI_TYPE_BUFFER;
> +	in_params[2].buffer.length = 512;
> +	in_params[1].buffer.pointer = (u8 *)ap->device[1].id;

Must be a typo. [2]
