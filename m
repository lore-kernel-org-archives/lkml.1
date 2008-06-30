Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbYF3WvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbYF3WvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763469AbYF3WvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:51:11 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48235 "EHLO
	ns1.utah-nac.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762159AbYF3WvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:51:10 -0400
Message-ID: <1929.69.2.248.210.1214865588.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 30 Jun 2008 16:39:48 -0600 (MDT)
Subject: [ANNOUNCE] Forensic File System GUID Linux/Windows and patches
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
Cc: jmerkey@wolfmountaingroup.com
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: <2778.69.2.248.210.1214248946.squirrel@webmail.wolfmountaingroup.com>  
     <48614755.5080001@zytor.com>
In-Reply-To: <48614755.5080001@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following GUID is being used in the Wolf Mountain Group, Inc.
Forensic File System (FFS) for GPT intel EFI partitions.  Since there is no
 central registry for EFI GUID's it is posted here for referece for folks
who may run across it on Windows Vista, 2003, and 2008 systems running
ForenFS on Windows that may be using dual boot with Linux or vmware:

#define PARTITION_FORENFS_GUID \
    EFI_GUID(0x83968a41, 0x5fe6, 0x4f9e, \
              0x91, 0x11, 0x52, 0xcf, 0x82, 0x8c, 0x51, 0x0a)

As per Peter Anvin's suggestion, uuidgen -r was used to regenerate the
uuid value for the Forensic Filesystem and I have updated the Windows code
base to reflect this change.   As per Lennart Sorensen's suggestion, the
FS name has been changed to "ForenFS" to avoid yet another driver named
"ffs".

The following patches, utilities, etc. are being posted to support Linux
accessing these partitions under EFI GPT.

ftp://ftp.wolfmountaingroup.org/pub/parted/parted-1.8.8-forenfs-06-30-08.patch
ftp://ftp.wolfmountaingroup.org/pub/parted/parted-1.8.8-forenfs.tar.gz
ftp://ftp.wolfmountaingroup.org/pub/parted/parted-1.8.8.tar.gz

EFI GPT changes to Linux to detect these partitions are in the attached patch

ftp://ftp.wolfmountaingroup.org/pub/forenfs/forenfs-2.6.18-el5-06-30-08.patch

Jeffrey Vernon Merkey





