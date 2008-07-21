Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYGUSfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYGUSfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYGUSe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:34:59 -0400
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:41944 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYGUSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:34:59 -0400
Message-ID: <4884D6CF.2070306@numericable.fr>
Date: Mon, 21 Jul 2008 20:34:55 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 3.0a1 (X11/2008051919)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.26-git7] ACPI warning (perhaps conflict) on boot with SMBus
 host controler (piix4)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

When trying the very latest git kernel (2.6.26-git7) I got this warning 
in dmesg on boot, about ACPI and PIIX4 SMBus controller :

[    4.770406] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts 
with ACPI region SMOV [0xb00-0xb06]
[    4.771726] ACPI: Device needs an ACPI driver
[    4.773035] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, 
revision 0

But my amd64 box works fine and I haven't notice any dysfunction on it. 
The 26-git6 kernel doesn't cause such a warning.

Regards.
