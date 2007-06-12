Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbXFLPpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbXFLPpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbXFLPpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:45:35 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:17559 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbXFLPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=L+LK8R8SnONdvbInxRZQaSokyR1ygp8V5OXIiHEjfV9bxDGl8TwCsQm/jGhXUNDz7RUha1mu5Sf+obIF1iL6lvh6VGmTAydww7Qg3D4N601AEvHpPjN+KbN3TC81UQxmhw29MjwohslvJBF51/jk30FE7IAo8WnCelbH184BcOI=
Message-ID: <466EBF91.8060508@gmail.com>
Date: Wed, 13 Jun 2007 00:45:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       =?ISO-8859-1?Q?Dagfinn_Ilmari_Manns=E5?= =?ISO-8859-1?Q?ker?= 
	<ilmari@ilmari.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
References: <20070612011148.GA9808@khazad-dum.debian.net> <466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org> <20070612121819.GA20408@khazad-dum.debian.net> <20070612135010.GA12601@srcf.ucam.org> <20070612141714.GB20408@khazad-dum.debian.net> <20070612153828.GA13888@srcf.ucam.org>
In-Reply-To: <20070612153828.GA13888@srcf.ucam.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Jun 12, 2007 at 11:17:14AM -0300, Henrique de Moraes Holschuh wrote:
>> On Tue, 12 Jun 2007, Matthew Garrett wrote:
>>> Laptop bays are designed to deal with hotplugging PATA - I don't think 
>>> this is too much of an issue :)
>> The new SATA ones use the SATA hardware hotplug ;-)   Just like the pci-e
>> cards use usb2.0 and pci-e hotplug...
> 
> Yes, but they'll also send an ACPI interrupt even if the SATA host 
> controller doesn't - it's part of the spec for bays.

Does the spec mandate that the ACPI interrupt shouldn't depend on SATA
phy status?  I don't think vendors are likely to implement separate
mechanism when SATA phy status can do the job fine.

-- 
tejun
