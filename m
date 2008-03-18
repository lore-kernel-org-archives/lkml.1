Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYCRGQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYCRGQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 02:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYCRGQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 02:16:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:4914 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYCRGQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 02:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gnnkqDr5fAUl1K6q4U2SeNiheMZeJMJ92Sw7xCjFFWwBmtzbsNMSYQDBFWR0qYAyyt0xfkLLI9/dfIMhLuHNL4ecdiTLceDEq/sQaTp/HWiMV1rPv7RMGSm1ipMURZ3LN1ugGA6CidShJ/qZpTBsAM9C8vddcxwXt+gmduUu9nY=
Message-ID: <47DF5E38.3030007@gmail.com>
Date: Tue, 18 Mar 2008 15:16:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Thomas Meyer <thomas@m3y3r.de>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-acpi@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jeff@garzik.org
Subject: Re: [PATCH] Re: In function `ata_acpi_associate': undefined reference
 to `register_hotplug_dock_device'
References: <47DEC970.2050402@m3y3r.de> <47DECD54.5060202@m3y3r.de> <200803172357.54253.lenb@kernel.org> <200803180011.49190.lenb@kernel.org>
In-Reply-To: <200803180011.49190.lenb@kernel.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> Subject: fix ATA_ACPI build
> From: Len Brown <len.brown@intel.com>
> 
> drivers/ata/libata-acpi.c fails to build
> 
> drivers/built-in.o: In function `ata_acpi_associate':
> (.text+0x7106a): undefined reference to `register_hotplug_dock_device'
> 
> When CONFIG_ATA_ACPI=y and CONFIG_ACPI_DOCK=m
> But if dock is selected from ata_acpi, dock will =y
> when ata_acpi=y, avoiding this problem.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: Tejun Heo <htejun@gmail.com>

I think this one will be more straight forward for users.

Thanks.

-- 
tejun
