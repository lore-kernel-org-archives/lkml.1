Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbYETL7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbYETL7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYETL66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:58:58 -0400
Received: from wr-out-0708.google.com ([64.233.184.248]:65042 "EHLO
	wr-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYETL66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:58:58 -0400
MIME-Version: 1.0
Message-ID: <12bd24d7-17d4-4df8-abca-42740ec309fe@x35g2000hsb.googlegroups.com>
Date: Tue, 20 May 2008 04:58:55 -0700 (PDT)
In-Reply-To: <avxTs-570-21@gated-at.bofh.it>
X-IP: 144.32.126.16
References: <avxTs-570-21@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (compatible; Konqueror/3.5; Linux) KHTML/3.5.9 
	(like Gecko) (Kubuntu),gzip(gfe),gzip(gfe)
X-HTTP-Via: 1.1 wc0.york.ac.uk:3128 (squid)
Subject: Re: Loading DSDT from initrd, can it be done from grub instead?
From: Alan Jenkins <aj504@cs.york.ac.uk>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Härdeman wrote:
> In commit 9a9e0d685553af76cb6ae2af93cca4913e7fcd47 the
> ACPI_CUSTOM_DSDT_INITRD option was removed.
>
> I was wondering if it'd be feasible to hack grub to load a custom DSDT
> instead (since grub can read filesystems) and then pass a pointer to a
> memory location containing the DSDT to the kernel?

Um, why?  What stops you from reverting the offending commit?

Without further info, I'd assume the feature was removed on policy
grounds.  I.e. it's not nice to be effectively patching the BIOS
yourself, and vendors have fixed most of their BIOS's / linux is
slightly more tolerant to broken ones.  I don't know whats wrong with
reading files from the initrd.

Alan
