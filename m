Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbXAaE6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbXAaE6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 23:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXAaE6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 23:58:04 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:29476 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbXAaE6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 23:58:01 -0500
Date: Tue, 30 Jan 2007 22:55:38 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Reducing warning output from pci_get_subsys()
Message-ID: <Pine.LNX.4.64.0701302251520.5644@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

There was some code added to warn if pci_get_subsys() is called and the 
pci_devices is empty.

I'm wondering if there is some point at which we know its ok for the 
pci_devices list be empty if there are no devices on the bus so we can 
stop printing the message.

On an embedded PPC reference system I see this message 6 times when I've 
got no cards in the PCI slots.

- k
