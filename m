Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYKKLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYKKLqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYKKLqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:46:05 -0500
Received: from sceest02.correodeempresas.telefonica.es ([212.170.236.203]:52509
	"EHLO sceest02.correodeempresas.telefonica.es" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403AbYKKLqE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:46:04 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Regression: Boot hang sizing transparent PCI-to-PCI bridgesinceafter 2.6.25-r7.
Date: Tue, 11 Nov 2008 12:43:28 +0100
Message-ID: <D913A682D10DBA4097B5D068D281B09B0266F9CB@S1128EXE.bbva.igrupobbva>
In-Reply-To: <49196DA1.3040104@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression: Boot hang sizing transparent PCI-to-PCI bridgesinceafter 2.6.25-r7.
Thread-Index: AclD8Uj29uAuGL95TQWM1Jd7Z0tr2QAACE1Q
References: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva> <49180973.6080808@gmail.com> <20081110175815.GA7650@us.ibm.com> <D913A682D10DBA4097B5D068D281B09B0266F9B0@S1128EXE.bbva.igrupobbva> <49196DA1.3040104@gmail.com>
From: "GARCIA DE SORIA LUCENA, JUAN JESUS" <juanj.g_soria@grupobbva.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: "Gary Hade" <garyhade@us.ibm.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Nov 2008 11:43:29.0577 (UTC) FILETIME=[B7745190:01C943F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jiri Slaby [mailto:jirislaby@gmail.com] 
>
> GARCIA DE SORIA LUCENA, JUAN JESUS napsal(a):
> > resource_size_t type
> > (defined in linux/types.h) being u64. Perhaps it's u32 in a 32 bit 
> > architecture.
> 
> Unless you have RESOURCES_64BIT=y which is the default on x86_32 now.

Ugh. Knowing this will save me from downloading, burning and testing the
32 bit Ubuntu distro, whose 2.6.27 kernel will surely use that default
configuration.

I'll perform more tests, with more debug kprintf()'s, anyway.

Do you remember if the cases Gary's patches were trying to fix included
ranges rolling past the 32-bit address limit (end address below start
address)?


Regards,

   Juan Jesus.
