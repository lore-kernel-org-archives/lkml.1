Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYBPGiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYBPGiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYBPGiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:38:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:60588 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYBPGiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=l7NGB8AVSWz2qQQC10mOl5UqX+qqtyc1HMJG2vXhePggeT/qGl6RK0uSxp0e8x0s6MHVrXet/laxZdjDu8FJWHEk7Y0qCZGPQ3KQ61xF+UgBhcIC8IZIwDlhOTOw2j6zaFZbpp1WKSWIuBzkZ5hUYMFhz7r79rQnOlNj1AiBRlI=
Message-ID: <f0cc3e3e0802152238t59498e3bv229d02ee3d96cea7@mail.gmail.com>
Date: Sat, 16 Feb 2008 17:38:13 +1100
From: "Omar Kilani" <omar.kilani@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: aacraid: Host adapter reset request. SCSI hang ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

We're having issues with our Adaptec RAID controller and I was
wondering if anyone would be able to advise on how to go about
resolving them. :)

The system:

RHEL 5.1 x86_64
Kernel 2.6.18-53.1.4.el5
aacraid 1.1-5[2437]-mh4 (The default module shipped with the RHEL kernel)

The controller:

Adaptec 3405 + BBU

BIOS : 5.2-0 (12415)
Firmware : 5.2-0 (12415)
Driver : 1.1-5 (2437)
Boot Flash : 5.2-0 (12415)

The disks:

4x Seagate ST373455SS (Firmware 0002) in a RAID10

The issue:

We continually get what seem to be adapter lockups with the error:

aacraid: Host adapter abort request (3,0,0,0)
aacraid: Host adapter reset request. SCSI hang ?

The controller hangs for a while, recovers, and everything continues normally.

We've tried a replacement controller and a replacement set of disks
(we swapped out all 4 disks) to no avail.

The problem seems (?) to happen during spikes of IO -- like when the
PostgreSQL autovacuum daemon kicks in. But not always.

>From searching around LKML and Google, this seems to be a fairly
common issue, but I'm not quite clear on the cause (hardware?
software? firmware?) or the resolution.

Any help would be greatly appreciated.

Thanks!

Regards,
Omar
