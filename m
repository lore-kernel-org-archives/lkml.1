Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXGYTOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXGYTOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935340AbXGYTOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:14:00 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:2931 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935313AbXGYTN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eOCWQUEURRJlslUqcubUt0ugoIzV+dgj5y0TtJtTEavvp9GGzw5zS7jL2UzXzT4UycRecb0zIcbG+9SnhPkaFr1OatugvR//Rcuw6y9L6UfmtU1q4Av0+gVmseyajTV+9YY9u8K+olPY9y+0RvHViYV7/J5Qvrw0i4ovyHufAiU=
Message-ID: <64bb37e0707251213t6edcb0a5sabcf4a923c19bde7@mail.gmail.com>
Date: Wed, 25 Jul 2007 21:13:57 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm1
Cc: "Len Brown" <lenb@kernel.org>, "Cedric Le Goater" <clg@fr.ibm.com>,
       linux-kernel@vger.kernel.org, "Shaohua Li" <shaohua.li@intel.com>
In-Reply-To: <20070725115804.5b8efe83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	 <46A7411C.80202@fr.ibm.com> <200707251323.04594.lenb@kernel.org>
	 <20070725115804.5b8efe83.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 25 Jul 2007 13:23:04 -0400
> Len Brown <lenb@kernel.org> wrote:
>
> > Andrew, you want to re-pull the acpi tree, or do you want me to send
> > you some patches on top of the current mm?
>
> I'd appreciate a fix for this one, please - I'll drop it int he hot-fixes
> directory as quite a few people seem to be hitting this.

I hit something similar:

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `acpi_pci_choose_state':
drivers/pci/pci-acpi.c:253: undefined reference to `acpi_pm_device_sleep_state'
drivers/built-in.o: In function `pnpacpi_suspend':
drivers/pnp/pnpacpi/core.c:124: undefined reference to
`acpi_pm_device_sleep_state'
make: *** [.tmp_vmlinux1] Error 1

I also have CONFIG_SMP=y and CONFIG_HOTPLUG_CPU=n

Will try to investigate more...

Torsten
