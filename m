Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbXDOUbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbXDOUbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbXDOUbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:31:52 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:44584 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbXDOUbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:31:51 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Date: Sun, 15 Apr 2007 14:31:41 -0600
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
References: <45D5EA88.7090300@redhat.com> <200704131459.45867.bjorn.helgaas@hp.com> <20070415114159.05026483@hyperion.delvare>
In-Reply-To: <20070415114159.05026483@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151431.41503.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 03:41, Jean Delvare wrote:
> On Fri, 13 Apr 2007 14:59:45 -0600, Bjorn Helgaas wrote:
> > Of course, there are always BIOS defects.  But if we could make a
> > case that a BIOS that doesn't declare the resources used by the AML
> > is defective, we could add quirks to reserve the undeclared resources.
> 
> Only realistic if the list of systems needing a quirk is small. Do you
> think that would be the case?

I don't know.  I confess that I don't clearly understand the problem
yet.  It sounds like the sensor drivers want to talk to hardware that
ACPI methods might also use.

But I missed the details, such as the specific devices in question,
which ports they use, how they are described in ACPI, which AML
methods use those ports, and which non-ACPI drivers also use them.

It also sounds like the non-ACPI drivers provide much more
functionality than ACPI exposes.  I'd like to understand this,
too, because an  obvious way to solve the problem would be to
drop the non-ACPI drivers.  Is this extra functionality available
on Windows?  If so, do we know whether Windows uses non-ACPI drivers
or whether they have some smarter way to use ACPI?  In the long
run, I think the easiest, most reliable route would be to use the
system in a similar way.  Then we'd be doing things the way the
manufacturer intended and we'd take advantage of all the Windows-
focused firmware testing.

Bjorn
