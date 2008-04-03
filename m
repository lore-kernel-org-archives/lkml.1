Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbYDCGtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbYDCGtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 02:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbYDCGsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 02:48:53 -0400
Received: from mail.southpole.se ([193.12.106.18]:40174 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbYDCGsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 02:48:53 -0400
Message-ID: <47F47DD3.8090402@southpole.se>
Date: Thu, 03 Apr 2008 08:48:51 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: struct pci_device_id cleanups
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the "net" branch of my repo, there are a series of changesets that 
modify the definition of struct pci_device_id to use the macro 
DEFINE_PCI_DEVICE_TABLE.  All the changesets in the public tree are 
one-liners of the type:

-static struct pci_device_id myri10ge_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(myri10ge_pci_tbl) = {
	...

The change to using this macro has two effects:
i)  Makes the structure 'const'
ii)  Puts the structure in section __devinitconst

Both these changes are as per the documentation.

Please pull and review these changes from the "net" branch at:

git://www.southpole.se/~jonas/git/linux.git

Regards,
Jonas


