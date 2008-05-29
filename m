Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbYE2VFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbYE2VFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYE2VFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:05:47 -0400
Received: from smtp-01.datacomm.ch ([212.40.2.26]:38796 "EHLO
	smtp-01.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYE2VFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:05:46 -0400
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1212086641.4625.56.camel@localhost.localdomain>
References: <1211717435.6038.53.camel@localhost.localdomain>
	 <20080525173825.GA4132@ucw.cz>
	 <1211746106.6188.57.camel@localhost.localdomain>
	 <20080525203921.GB18781@elf.ucw.cz> <20080525211016.GA32478@elf.ucw.cz>
	 <1211815881.6140.19.camel@localhost.localdomain>
	 <20080527112236.GA13957@elf.ucw.cz>
	 <1212086641.4625.56.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 29 May 2008 23:05:44 +0200
Message-Id: <1212095144.7328.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * I get 
> "ACPI: Unable to turn cooling device [ffff81012fa5cdd0] 'off'" every two
> seconds and "fancontrol" isn't working any more... going to send a
> acpidump to the acpi group. Maybe i'll find out myself as well...
> investigating. Not sure if it's caused by the patch.

It's caused by the suspend/resume process, not the patch - it happens
with the unpatched -rc4 kernel and mem=4G as well after resume.

"fancontrol" needed a config file update only (new device, hwmon0).

