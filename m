Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYE3RDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYE3RDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYE3RDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:03:16 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:38683 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752564AbYE3RDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:03:15 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 13:03:15 EDT
Date: Fri, 30 May 2008 12:55:50 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: linux-kernel@vger.kernel.org
Subject: EDAC i5000 MC0: NON-FATAL ERRORS
Message-ID: <20080530165550.GA23698@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   I am seeing the following errors on a Fedora 7 x86_64 linux box,
running on a Tyan Tempest i5000XL motherboard, after upgrading from
kernel-2.6.25-14.fc9.x86_64 to kernel-2.6.25.3-18.fc9.x86_64...

May 25 04:30:56 fourier kernel: EDAC i5000 MC0: NON-FATAL ERRORS Found!!! 1st NON-FATAL Err Reg= 0x10000
May 25 04:30:56 fourier kernel: EDAC MC0: CE row 1, channel 0, label "": (Branch=0 DRAM-Bank=3 RDWR=Read RAS=14339 CAS=672, CE Err=0x10000)

These messages occur about once an hour and are always for the same DRAM-Bank.
I've not been able to find any memory errors when running memtest86 with or
without ECC checking being enabled. Are there any known issues with the
EDAC support in the kernel that might cause false positives like this?
The errors are always marked as non-fatal and are for reads. Also, does
anyone know how this code numbers ram banks? Is the first ram bank considered
0 or 1 by this code? Thanks in advance for any clarifications.
                    Jack
