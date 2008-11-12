Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYKLXj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYKLXj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYKLXef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:34:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52646 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYKLXee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:34:34 -0500
Date: Wed, 12 Nov 2008 23:34:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
Message-ID: <20081112233430.GA22893@srcf.ucam.org>
References: <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk> <20081104151128.GA22544@srcf.ucam.org> <49106DD7.9010307@tuffmail.co.uk> <20081104155722.GA23314@srcf.ucam.org> <491076BD.1030704@tuffmail.co.uk> <49170B16.4010909@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49170B16.4010909@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, from looking at the Microsoft docs 
(http://download.microsoft.com/download/9/c/5/9c5b2167-8017-4bae-9fde-d599bac8184a/BIOS_PCIe_HotPlug.doc) 
I suspect this is the wrong way to go - they make it sound like native 
PCIe hotplug is only supported in Vista and later, so we probably ought 
to be doing something with ACPI instead. I'll look into that later this 
week.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
