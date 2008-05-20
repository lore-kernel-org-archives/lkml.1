Return-Path: <linux-kernel-owner+w=401wt.eu-S1765852AbYETMK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765852AbYETMK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760427AbYETMKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:10:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:14933 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYETMKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VWyISeKWd4V+9UejXqhfaFDgawsatG3XEyfd5xNHQgafcC+TBXJ6rjr1Zs4jZu3XDqXKtTAVgJmwlSPmDl6eM7mXiLTzxz7nGyz2w1kvqe17a8+LnCGFCxQOUEuXuUMuJscro2nmmazSNyNlOUOqrzs8Rdxh0TAKwYJTpewNkCE=
Message-ID: <4832BF97.2070405@googlemail.com>
Date: Tue, 20 May 2008 14:09:59 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Alan Jenkins <aj504@cs.york.ac.uk>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
       linux-kernel@vger.kernel.org
Subject: Re: Loading DSDT from initrd, can it be done from grub instead?
References: <avxTs-570-21@gated-at.bofh.it> <12bd24d7-17d4-4df8-abca-42740ec309fe@x35g2000hsb.googlegroups.com>
In-Reply-To: <12bd24d7-17d4-4df8-abca-42740ec309fe@x35g2000hsb.googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:

> David Härdeman wrote:
>> In commit 9a9e0d685553af76cb6ae2af93cca4913e7fcd47 the
>> ACPI_CUSTOM_DSDT_INITRD option was removed.
>>
>> I was wondering if it'd be feasible to hack grub to load a custom DSDT
>> instead (since grub can read filesystems) and then pass a pointer to a
>> memory location containing the DSDT to the kernel?
> 
> Um, why?  What stops you from reverting the offending commit?
> 
> Without further info, I'd assume the feature was removed on policy
> grounds.  I.e. it's not nice to be effectively patching the BIOS
> yourself, and vendors have fixed most of their BIOS's / linux is
> slightly more tolerant to broken ones.  I don't know whats wrong with
> reading files from the initrd.


It was reverted because the code was not really ready and caused some problems.

> 
> Alan

Gabriel

