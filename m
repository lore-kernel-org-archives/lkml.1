Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbXK0KNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbXK0KNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXK0KNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:13:23 -0500
Received: from mout0.freenet.de ([195.4.92.90]:42086 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbXK0KNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:13:22 -0500
Message-ID: <474BEDAB.3000305@de.ibm.com>
Date: Tue, 27 Nov 2007 11:12:59 +0100
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: carsteno@de.ibm.com, Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       kvm-devel@lists.sourceforge.net, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>	<4743076F.8000105@qumranet.com>	<47435CCB.1050506@us.ibm.com>	<4743DAA4.70800@qumranet.com>	<4747051C.3090903@us.ibm.com> <4747122F.1070905@qumranet.com>	<474B1BF3.20901@us.ibm.com> <474BDD28.7050801@qumranet.com> <474BDEDE.6060603@de.ibm.com> <474BE319.502@qumranet.com>
In-Reply-To: <474BE319.502@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Unfortunately, we have to care for platform differences, subarch 
> differences (vmx/svm), hypervisor differences (with virtio), and guest 
> differences (Linux/Windows/pvLinux, 32/64).  Much care is needed when 
> designing the ABI here.
Yea, I agree.

> [actually thinking a bit, this is specific to the virtio pci binding; 
> s390 will never see any of it]
You remember that we've lost the big debate around virtio in Tucson? 
We intend to bind our virtio devices to PCI too, so that they look the 
same in Linux userland across architectures.
