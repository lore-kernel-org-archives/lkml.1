Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbYGAOSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbYGAOSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbYGAOSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:18:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbYGAOSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:18:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: dsdt buggy acpi
Date: Tue, 1 Jul 2008 16:19:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
In-Reply-To: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011619.53339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Justin Mattock wrote:
> With not knowing what I'm doing, I think I need assistance. With looking at acpi
> I decided to have a try at the dsdt.dat bit(pretty easy so far) except
> I'm being confronted with some errors, in of which
> I don't know how to resolve(still Googling for the answer) If anybody
> has any answers it would sure be appreciated.
> errors below:
> 
> Intel ACPI Component Architecture
> ASL Optimizing Compiler version 20051216 [Jan  9 2006]
> Copyright (C) 2000 - 2005 Intel Corporation
> Supports ACPI Specification Revision 3.0
> 
> No back ptr to Op: type 8
> No back ptr to Op: type 8
> dsdt.dsl   511:             If (And (PDC0, 0x08))
> Error    1061 -   Object does not exist ^  (PDC0)
> 
> dsdt.dsl   514:                 If (And (PDC0, 0x10))
> Error    1061 -       Object does not exist ^  (PDC0)
> 
> dsdt.dsl   521:             If (And (PDC1, 0x08))
> Error    1065 -                         ^ Object not accessible from
> this scope (PDC1)
> 
> dsdt.dsl   524:                 If (And (PDC1, 0x10))
> Error    1065 -                             ^ Object not accessible
> from this scope (PDC1)
> 
> ASL Input:  dsdt.dsl - 5040 lines, 171343 bytes, 1814 keywords
> Compilation complete. 4 Errors, 0 Warnings, 0 Remarks, 609 Optimizations
> 
> I'm figuring if I can at least fix this, then maybe this will help
> with: http://bugzilla.kernel.org/show_bug.cgi?id=10724
> acpi gpe storm regression.(or at least get me this much closer to
> figuring out what is up with that).

Please have a look at http://www.lesswatts.org/projects/acpi/

Thanks,
Rafael
