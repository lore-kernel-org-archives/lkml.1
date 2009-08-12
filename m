Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZHLRJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZHLRJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZHLRJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:09:41 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:36329 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZHLRJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZOS/cZ6IgmIxK8oubNLHH4JxFSIKmp3efHyu6hheM/DkUSoYAceCycM3muqsJ1C0vL
         08U5yLF3wu4Wcb/52j51z/+CBn+t/jspV8l4JuNrvJcjUFWliEKKXZlzlL89wqHNIs/J
         Jx97S5bzKw4R7/hOtQMJ+SYhghycfBt4ry7gY=
MIME-Version: 1.0
In-Reply-To: <20090805235009.88C091007F@gold.linx.net>
References: <20090805235009.88C091007F@gold.linx.net>
Date: Wed, 12 Aug 2009 19:03:05 +0200
Message-ID: <c384c5ea0908121003x2f3eef3ejd8bc4a5aaa120793@mail.gmail.com>
Subject: Re: [PATCH 2.6.32 v3] Conditional MSI support for sata_nv
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Tony Vroon <tony@linx.net>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       Robert Hancock <hancockrwd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 6, 2009 at 1:50 AM, Tony Vroon<tony@linx.net> wrote:
> At least the nVidia MCP55 controller quite happily supports MSI.
> +static int msi_enabled;
> +       if (msi_enabled) {
> +               dev_printk(KERN_NOTICE, &pdev->dev, "Using MSI\n");
> +               pci_enable_msi(pdev);
> +       }
> +

I just saw this patch, didn't check the full sources.

Shouldn't there be a matching "if (msi_enabled)
pci_disabling_msi(pdev);" somewhere else?

Regards,

Leon.
