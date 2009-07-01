Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZGAKBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZGAKBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZGAKBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:01:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37352 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754313AbZGAKBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:01:20 -0400
Date: Wed, 1 Jul 2009 11:01:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andy Isaacson <adi@vmware.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       adi@hexapodia.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com,
       Andy Isaacson <adi@vmware.com>
Subject: Re: [PATCH 5/6] tpm_tis: convert from pnp_driver to acpi_driver
Message-ID: <20090701110136.576a1d14@lxorguk.ukuu.org.uk>
In-Reply-To: <1246410255-6839-6-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	<1246410255-6839-6-git-send-email-adi@vmware.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 18:04:14 -0700
Andy Isaacson <adi@vmware.com> wrote:

> Not all TIS-compatible TPM chips have a _HID method in their ACPI entry,
> and the TPM spec says that the _CID method should be used to enumerate
> the TPM chip.

There are a number of systems with TPMs (older laptops) that don't work
very well if you enable ACPI.

This is therefore a regression - NAK

Probably the best thing to do is to provide both ACPI and PnP
registration according to what is configured into the kernel. (And I
guess spot duplicates although the resource should be busy anyway)
