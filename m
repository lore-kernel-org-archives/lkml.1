Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbXJBVIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbXJBVIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbXJBVIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:08:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:34791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbXJBVIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,221,1188802800"; 
   d="scan'208";a="160939856"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Announce: Linux-ready Firmware Dev Kit  - Release 3
Date: Tue, 2 Oct 2007 14:08:14 -0700
Message-ID: <F8A0EBD0F30CA24B974BD57423860EAE04246880@orsmsx415.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Announce: Linux-ready Firmware Dev Kit  - Release 3
Thread-Index: AcgFF9MCnSLin4gWS3S2bNgx1DKUkwAABxnQAAfsCpAAAAh78A==
From: "Selbak, Rolla N" <rolla.n.selbak@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Oct 2007 21:08:15.0892 (UTC) FILETIME=[598F2540:01C80538]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The Linux-ready Firmware Developer Kit team is pleased to announce the
release R3 of the kit. 

The project is fairly stable at this point, but there are still many
new, exciting 
additions to the kit such as Linux PowerTop 1.8, a tool to monitor power
usage, 
c-states and p-states.  See http://www.linuxpowertop.org/ for more info.

The default kernels that are tested by the kit are also updated to now
include:
kernel.org 2.6.22-9, FC6, Ubuntu 7.04 and Mandriva 2007.1.  There are
also
changes to make it as simple as possible to build your own customized
firmwarekit to include the kernels _you_ care about.  Corresponding
documentation
is, of course, included. See 'HOWTO_CustomizeISO.txt' for easy
instructions.

The Linux-ready Firmware Developer Kit is a tool to test how well Linux
works together with the firmware (BIOS or EFI) of your machine, and is
designed for use by both firmware development teams and Linux kernel
hackers to prevent and diagnose firmware bugs.

Summary
=======

Enhancements
============
* Added Ubuntu 7.04 kernel and Mandriva 2007.1 kernel as part of the
kernels to test
* Added error log for the plugins' stderr outputs (lfdk.err.log)
* Root 'make' now just strictly compiles the plugins, leaving the
downloading and other
tasks to 'make iso'.
* Re-org of extracting acpi tables in a more logical, efficient way
(thanks to Thomas Reninger)
* Updated microcode .dat file
* Versioning is now soft-coded with get_lfdk_ver() instead of hard-coded
* Removed all hard-coded instances of system commands, and instead
created get_relative_command()
* Results now strictly in .txt format, removed .xml.
* Bug-fixes and maintenance
* More & updated documentation including:
	- HOWTO_CustomizeISO - add your own kernels to the kit for
testing
	- HOWTO_WritePluginTest - easy steps in how to write your own
plugin tests
	- Implementation section of README (finally) - overview of the
implementation of the kit


New Tests
=========
* Virtualization tests for svm and vmx submitted by Lijo Lazar
* (experimental) DMAR to test the health of the acpi DMAR tables
(original patch by Shaohua Li from Intel)
* Linux PowerTop 1.8
* Added test in pci resource plugin for failure to allocate memory
resources (refer to
Linus' comment in http://bugzilla.kernel.org/show_bug.cgi?id=7917)


You can download this latest release of the kit from

    http://www.linuxfirmwarekit.org


The Linux-ready Firmware Developer Kit team
	Jacob Pan
	Rolla Selbak
	Arjan van de Ven


(please cc my email on any replies or comments)

Thanks,

rs
