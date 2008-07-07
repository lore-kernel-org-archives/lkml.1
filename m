Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYGGDyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYGGDyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 23:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYGGDyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 23:54:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:16487 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYGGDyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 23:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DwT3/6zLO7lbi/ZwCJCrWfbFfkejFmNpepWNkdN0oyuQrhYrrojbvoE/ZxNfDGGFAh
         +rRab9ku2kyUyHTAu86qHYVj87CZtrTSaYJwCvp0N85/wB4kzVLLmyTMBfCR4c09Nd2N
         81PFz1E0Er9ez1CIlYgAkKLxO5uLgre9R7+bs=
Message-ID: <ac8af0be0807062054nbced6b0pd378aeda91a3c538@mail.gmail.com>
Date: Mon, 7 Jul 2008 11:54:01 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Cc: "Ingo Molnar" <mingo@elte.hu>, "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Len Brown" <lenb@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
>
>  Matthew, you have not added your sign-off with the original patch, please
> do so now.
>
>  Rafael, please try this change together with
> patch-2.6.26-rc1-20080505-mpparse-acpi-noirq0-2 and see if this fixes your
> system.
>
>  I have tried the patches with a wildcard entry added to acpi_dmi_table[]
> so that it trips for my system.  The result is as follows:

Since we add a new entry to acpi_dmi_table[], I think it's necessary
for this new entry to preserve the semantics of this table, that is
"acpi=force overrules DMI blacklist", am I right?

Thanks,
Forrest
