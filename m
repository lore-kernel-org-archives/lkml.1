Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYGAGjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYGAGjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYGAGjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:39:40 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:50090 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYGAGjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=HYg5paCye4cPA+HXCHg1ZOx+gvGYYJ5KvjJOrPzK7sNEKdFd2fBmOyCf0N1YK6TGux
         IPeey+YiEpmWxrVCEL8PViGqytZnnACqYxOm1N2qBEHMq+i0kRwU91D5SjCRhOC2efBJ
         2/Z/Ji+4YolcFp0nk4o2H+5VOwtRQwDutOdgE=
Message-ID: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
Date: Tue, 1 Jul 2008 06:39:38 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: dsdt buggy acpi
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With not knowing what I'm doing, I think I need assistance. With looking at acpi
I decided to have a try at the dsdt.dat bit(pretty easy so far) except
I'm being confronted with some errors, in of which
I don't know how to resolve(still Googling for the answer) If anybody
has any answers it would sure be appreciated.
errors below:

Intel ACPI Component Architecture
ASL Optimizing Compiler version 20051216 [Jan  9 2006]
Copyright (C) 2000 - 2005 Intel Corporation
Supports ACPI Specification Revision 3.0

No back ptr to Op: type 8
No back ptr to Op: type 8
dsdt.dsl   511:             If (And (PDC0, 0x08))
Error    1061 -   Object does not exist ^  (PDC0)

dsdt.dsl   514:                 If (And (PDC0, 0x10))
Error    1061 -       Object does not exist ^  (PDC0)

dsdt.dsl   521:             If (And (PDC1, 0x08))
Error    1065 -                         ^ Object not accessible from
this scope (PDC1)

dsdt.dsl   524:                 If (And (PDC1, 0x10))
Error    1065 -                             ^ Object not accessible
from this scope (PDC1)

ASL Input:  dsdt.dsl - 5040 lines, 171343 bytes, 1814 keywords
Compilation complete. 4 Errors, 0 Warnings, 0 Remarks, 609 Optimizations

I'm figuring if I can at least fix this, then maybe this will help
with: http://bugzilla.kernel.org/show_bug.cgi?id=10724
acpi gpe storm regression.(or at least get me this much closer to
figuring out what is up with that).
regards;

-- 
Justin P. Mattock
