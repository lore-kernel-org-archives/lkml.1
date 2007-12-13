Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXLMKQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXLMKQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXLMKQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:16:34 -0500
Received: from mout1.freenet.de ([195.4.92.91]:52503 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbXLMKQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:16:33 -0500
Message-ID: <4761066D.6030809@de.ibm.com>
Date: Thu, 13 Dec 2007 11:16:13 +0100
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
CC: Arnd Bergmann <arnd@arndb.de>, kvm-devel@lists.sourceforge.net,
       heicars2@linux.vnet.ibm.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC] Proposed new directory layout for kvm and virtualization
References: <475E5CBB.9080608@qumranet.com> <20071211151143.GA7751@osiris.boeblingen.de.ibm.com> <475EB23E.1060002@qumranet.com> <200712120014.43314.arnd@arndb.de> <4760EE69.2090006@qumranet.com>
In-Reply-To: <4760EE69.2090006@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> In the case of x86, we'll have 16 arch dependent files (i8259.[ch], 
> irq.[ch], lapic.c, mmu.c, paging_tmpl.[ch], svm.[ch], vmx.[ch], 
> x86.[ch], x86_emulate.[ch]) which warrant a kvm/ subdirectory IMO.
I think a subdirectory makes sense too. We'll end up with more than a 
single file.
