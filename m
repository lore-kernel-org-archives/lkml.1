Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZBJAZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZBJAZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZBJAZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:25:44 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:46424 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZBJAZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:25:43 -0500
Subject: AW: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with2.6.29-rc3 on IBM x3400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Date: Tue, 10 Feb 2009 01:25:39 +0100
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F1E@exchange01.corp.win-professional.com>
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft Exchange V6.5
In-Reply-To: <20090209234528.GA862@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with2.6.29-rc3 on IBM x3400
Thread-Index: AcmLEIexCgdtmhOyTsK1G4UaNEmjtQABKlXQ
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Feb 2009 00:25:40.0267 (UTC) FILETIME=[1A3F57B0:01C98B16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> buggy BIOS most likely. Had the kernel not fixed up the MTRRs you'd have
> a very slow and unhappy system now.

the IBM support said the bios is okay and there is a issue with linux 2.6.28 and 2.6.29-rc3?
linux 2.6.26 (default debian kernel) works fine.

-

Morten

-----Ursprüngliche Nachricht-----
Von: Ingo Molnar [mailto:mingo@elte.hu] 
Gesendet: Dienstag, 10. Februar 2009 00:45
An: Morten P.D. Stevens; Yinghai Lu; Thomas Gleixner; H. Peter Anvin; Arjan van de Ven
Cc: linux-kernel@vger.kernel.org
Betreff: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with2.6.29-rc3 on IBM x3400


* Morten P.D. Stevens <mstevens@win-professional.com> wrote:

> Hi,
> 
> Update:
> 
> the same issue with a linux 2.6.28.4 kernel.
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 generic_get_mtrr+0xdf/0x119()
> [    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.

buggy BIOS most likely. Had the kernel not fixed up the MTRRs you'd have
a very slow and unhappy system now.

	Ingo
