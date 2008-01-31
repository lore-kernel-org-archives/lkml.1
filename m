Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbYAaVj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbYAaVj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbYAaVjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:39:18 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50719 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYAaVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:39:18 -0500
Date: Thu, 31 Jan 2008 22:39:16 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Frank Seidel <fseidel@suse.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nozomi: constify driver
In-Reply-To: <200801312210.30722.fseidel@suse.de>
Message-ID: <Pine.LNX.4.64.0801312238170.4864@fbirervta.pbzchgretzou.qr>
References: <200801312210.30722.fseidel@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31 2008 22:10, Frank Seidel wrote:
>
>This one is based on the last patch i sent
>(Re: [PATCH 012/196 ver2] nozomi driver) and is a rework
>of the nozomi constify patch from Jan Engelhardt.

It's hard to find what you actually reworked...

>-static struct pci_device_id nozomi_pci_tbl[] = {
>+static const struct pci_device_id nozomi_pci_tbl[] __devinitdata = {

This is bogus.

