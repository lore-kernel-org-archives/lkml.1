Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbYBONVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbYBONVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYBONVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:21:11 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:59151 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYBONVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:21:10 -0500
Date: Fri, 15 Feb 2008 14:21:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jeff Garzik <jeff@garzik.org>
cc: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 05/14] [ISDN] HiSax enternow: convert to PCI hotplug API
In-Reply-To: <61a39b593f15e52f75902baaa69bf033c4e302ac.1203031878.git.jeff@garzik.org>
Message-ID: <Pine.LNX.4.64.0802151419180.30301@fbirervta.pbzchgretzou.qr>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
 <61a39b593f15e52f75902baaa69bf033c4e302ac.1203031878.git.jeff@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 17 2007 23:49, Jeff Garzik wrote:

>+static struct pci_device_id en_pci_table[] = {
>+	{ PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_300, 0x55, 0x02, },
>+
>+	{ }		/* terminate list */
>+};

This can be

       v                                         v
static const struct pci_device_id en_pci_table[] __devinitconst = {
 ...
}

(also in other modules)
