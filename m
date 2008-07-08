Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYGHQaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYGHQaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYGHQ36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:29:58 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:14704 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYGHQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:29:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AtpAp8feTfkbuDh45Giv46NHSQXDAYAmeJeVsmLeOQNLlhaxEIpgmiKkaD5bU/T63j
         MXMkKtJSez2elY+NSHRy+s88hilvk6S9puapCYzlD3vfV2WJMdXS44cq2fgD8oMOpBs5
         xlMHoJl0FEx3+0Dcr8sx0+qOn/kXFktpPIA20=
Message-ID: <a4423d670807080929t3254393jc501e703d6ffb26e@mail.gmail.com>
Date: Tue, 8 Jul 2008 20:29:55 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: next-0708: build failure at drivers/pci/pci-acpi.c
Cc: jbarnes@virtuousgeek.org, ak@linux.intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200807081712.23937.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807080518g31402f60j2f624a2ac2db03aa@mail.gmail.com>
	 <200807081712.23937.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/8 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday, 8 of July 2008, Alexander Beregalov wrote:
>> Hi Rafael
>>
>> drivers/pci/pci-acpi.c: In function 'acpi_pci_sleep_wake':
>> drivers/pci/pci-acpi.c:311: error: implicit declaration of function
>> 'acpi_pm_device_sleep_wake'
>
> I guess this is a compilation with CONFIG_ACPI=y and CONFIG_PM_SLEEP unset.
Indeed.
>
> In that case the appended patch should help.  Please test and report back (I
> can't test linux-next compilation at the moment).

Compilation test passed and the kernel can boot.
