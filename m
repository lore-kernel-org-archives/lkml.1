Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYGNSJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYGNSJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYGNSJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:09:01 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:41987 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753803AbYGNSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:08:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 14:08:58 EDT
X-YMail-OSG: yV37IXYVM1m2TSg1HeLmIbDfcPXmP8VEyrRAZwDv0MVXEjCrjurXCqS28jf8t.V_VtVgDMD3salDEB5VTLg16NRkm91kmTqePm2oYEzSIWoqy9btSoGYRdbgXhRC_C4CMfzzqZ2gic9DUw5weDVj1pG.
X-Yahoo-Newman-Property: ymail-3
Subject: VHACS-VM x86_64 Alpha Preview on 45nm multicore
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jerome Martin <tramjoe.merin@gmail.com>,
       Ming Zhang <blackmagic02881@gmail.com>,
       "Ross S. W. Walker" <rwalker@medallion.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>,
       "Ted Ts'o" <tytso@thunk.org>, Christoph Hellwig <hch@lst.de>,
       Mike Mazarick <mazarick@bellsouth.net>,
       Rafiu Fakunle <rafiu@openfiler.com>, Hannes Reinecke <hare@suse.de>,
       Grant Grundler <grundler@google.com>, Matthew Wilcox <willy@debian.org>,
       "Love, Robert W" <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Beekhof <abeekhof@suse.de>,
       Michael Shiloh <michael@openmoko.org>,
       Sean Moss-Pultz <sean_mosko@fic.com.tw>,
       Bryan Black <bdblinux@gmail.com>, Sig Lange <sig.lange@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       Open iSCSI <open-iscsi@googlegroups.com>,
       OpenFabrics-General <general@lists.openfabrics.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 11:02:13 -0700
Message-Id: <1216058533.21408.83.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

I am pleased to announce the Alpha availibility of VHACS-VM Demo for
Hardware Virtualized x86_64 running (initially) on VMWare Workstation 6.
The VHACS cluster stack also obviously runs on 'bare-metal' hardware,
but today VHACS-VM is the easiest method to get your own open storage
cloud up and running.

What is VHACS..?

VHACS is a Cloud Storage implementation running on Linux v2.6. VHACS is
an acrynom for Virtualization, High Availibility, and Cluster Storage.
VHACS is a combination of at least eight (8) long term OSS/Linux based
projects, along with a CLI management interface for controlling VHACS
nodes, clouds, and vservers within the VHACS cluster.  Here is a quick
rundown of the projects (so far) that make up the VHACS cluster stack:

CLUSTER:

      * ) Pacemaker The scalable High-Availability cluster resource
        manager formerly part of Heartbeat
      * ) OpenAIS The OpenAIS Standards Based Cluster Framework is an
        OSI Certified implementation of the Service Availability Forum
        Application Interface Specification (AIS)

SERVER:

      * ) LIO-Target w/ IBLOCK LIO-Core subsystem plugin for iSCSI
        Target mode export
      * ) DRBD Distributed Replicated Block device for Network RAID 1
        Mirrors
      * ) Linux Logical Volume Manager (LVM) ('vhacs' volume group for
        creation of VHACS clouds)

CLIENT:

      * ) Open/iSCSI iSCSI Initiator client
      * ) Ext3 filesystem
      * ) Linux-Vserver Linux Virtualization Layer

I am happy to report that VHACS-VM Alpha Demo x86_64 is running 0.8.15
VHACS code, along with the many other pieces of open source
infrastructure that the VHACS cloud builds upon, and providing
Active/Active H/A with Synchronous Data Replication iSCSI Target ERL=2 /
MC/2 export that makes up the SERVER side of the VHACS cloud.  The
CLIENT side of the VHACS cloud is also running an iSCSI Initiator ext3
mounted filesystem with Open/iSCSI on top of Intel 45 nanometer
'Wolfdale' microprocessor silicon and DDR2 800 memory.

Futhermore, using commerically available x86 virtualization technology
on open/closed platforms, I am very happy to report that VHACS-VM 2x
node clusters are now up and running across both OPEN (Linux x86_64) and
CLOSED (win32) x86 platforms on top of the 45nm chips with the VMMU/VMX
parts enabled.  The first OS independent storage clouds running on top
of v2.6.25.9-kdb are now a reality.

Here is a link to the code, screenshots, and all the goodies:

http://linux-iscsi.org/index.php/VHACS-VM
http://linux-iscsi.org/index.php/VHACS

The VHACS-VM x86_64 system images, which contain a Debian Etch system
iamges running the very latest compontents that make up the VHACS
cluster stack.  Also included in the vhac64-west and vhacs64-east system
images is a complete development environment, including a KDB enabled
kernel that will allow the developer to pause the running image at any
time, examine memory, or setup a breakpoint to track down a problem.
The x86_64 system images currently require hardware x86 virtualization,
please see the wiki for more information about hardware requirements.
They are available from:

http://linux-iscsi.org/builds/VHACS-VM/x86_64/vmware6/

Also, there is great interest to see VHACS-VM running on KVM and QEMU
Virtualization platforms.  This is something that should not be too
difficult as long as the virtualization platform supports execution of
x86_64 system images.  i386 system images are also in the works to bring
the storage cloud to legacy environments without hardware x86_64
virtualization.

Enjoy,

--nab


