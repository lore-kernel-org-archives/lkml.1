Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbXKOUdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbXKOUdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbXKOUdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:33:10 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:45581 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756589AbXKOUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:33:08 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 15:33:08 EST
X-YMail-OSG: 1hE4pk4VM1lL3prepxwYagZH7b3RkHcxgG4HdcDMwdC3n4wkgf6Yt7mSMSE4W15vd6bBbKK_pUStRKI.mx1EMctP
Subject: [ANNOUNCE] - Linux-iSCSI.org Storage Engine goes online!
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       Open iSCSI <open-iscsi@googlegroups.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ming Zhang <blackmagic02881@gmail.com>,
       Robert Whitehead <WRWHITEHEAD@novell.com>,
       Matthew Wilcox <willy@debian.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@lst.de>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@osdl.org>, Mike Mazarick <mazarick@bellsouth.net>,
       Mike Young <myoung@wildernessvoice.com>,
       iet-dev <iscsitarget-devel@lists.sourceforge.net>,
       ips reflector <ips@ietf.org>
Cc: nab@kernel.org
Content-Type: text/plain
Date: Thu, 15 Nov 2007 12:25:44 -0800
Message-Id: <1195158344.4834.62.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

It is my great pleasure to announce that the Linux-iSCSI.org project has
reached its first 2.9-BETA release and its now offering the ability to
build source against any RPM or DEB based kernel and distribution.  The
Linux-iSCSI.org West cluster is offering binaries for CentOS 5 and
Debian 4, and instructions are now online.  This project provides the
infrastructure pieces required to run a production IP storage fabric,
and is constantly evolving.

The complete target stack, which is now available in source and binary
form @ Linux-iSCSI.org, allows the storage admin to combine
virtualization technologies (Xen, HVM, VMware), cluster filesystems
(OCFS2, GFS) and Linux kernel storage functionality (DM, LVM, MD) for
your very own IP storage cluster.  This IP storage cluster has been up
and running at Linux-iSCSI.org, and the guests are able to build their
packages on top of Linux OCFS2, and making iSCSI cluster storage
available for download at http://linux-iscsi.org/builds/

All together, the cluster has 16 GB of memory and 16x x86_64 cores with
cpuspeed lowering the clocks to 1Ghz where availabile.  There are total
of 10 virtual machines (6 paravirtualizated + 4 HVM) running iSCSI
storage between the two machines running the Target.  A handful of these
are currently in production using IPv4 and TCP and providing services to
Linux-iSCSI.org West.

On target storage is being exported via LVM block devices on top of a
software RAID6 SATA software on RHEL v4u5 using Linux-iSCSI.org on v2.9
on CentOS v4.  The storage objects are cut into 100 GB volumes and
imported into the target stack and the ports created to storage object
and portal group endpoints. From there the iSCSI endpoints are exported
to hosts and guests across a mixed-mode 1 and 10 Gb/sec networking
fabric.  IPv6 and SCTP support has also been included in current target
module builds, and moving the project's fabric to IPv6 is planned in the
near future.

Also, a little bit about the origins of the target stack, which is known
throughout the industry as the "PyX" stack.  The software, which has
been on constant development since the fall of 2001, has been behind
number 'worlds first' developments in the IP storage space, including a
10 Gb/sec throughput worlds record in Early 2005.  The target stack was
developed in parallel with an iSCSI initiator stack, known as
Core-ISCSI.  Recently, I have purchased the exclusive rights to the
software, and as the principle developer, have released the source code
under the GPL license.  The code is currently running the production
services for the Linux-iSCSI.org West cluster, and the project looking
for interested developers, admins, users and vendors.

As the implementation possibilities for IP storage are virtually
limitless, the goal of the project is to offer not just the software to
install and configure the environment, but the knowledge to create,
grow, reproduce, and maintain a complete open source IP storage fabric.
While it is possible today for those with the know-how and the time to
put these open source pieces together, there is a great opportunity to
benefit for not just developers, but end users, admins, and vendors who
are interested in what open source IP storage on Linux can do for them.

There much interest with Linux-iSCSI and virtulization technologies
lately, and I am happy to report that the first Linux-iSCSI.org target
running in guest mode has successfully exported locally attached disks
and optical drives, on both Linux and non-Linux hosts using VMware
Workstation 6.  As this will be surely be one of the popular uses of
Linux-iSCSI.org, and I am starting to collect the information for a
howto and eventually downloadable system images.  Please stay tuned for
this. :-)

While we have reached milestones at Linux-iSCSI.org recently, there is
still much work to be done.  Both in terms of the code, the
documentation, and the UI.  For the Target code that is in production, I
am working on a ncurses based shell for typical types of functionality.
As the interest starts to grow, this is going to be key piece of
reducing the learning curve for working with the Linux/iSCSI code. 

Also, the plan is to put the kernel code into a git tree on kernel.org
to determine which pieces should be headed toward the kernel.  While I
am sure there will be much debate about this subject, the immediate goal
has been to offer a production quality stack in the near term so that
kernel devs can have the time to get the code fragments ready, without a
large and hungry user community that is looking for useable code, and
not code persay that is still having bugs worked out.

While there are many iSCSI projects in the Linux universe, my hope is
that we as a community can come together in order to take advantage of
the tremendous amount of talent eager to learn.  There is also so much
excellent code available, that I hope we as developers can focus on
taking the best parts of each project and putting them together to
create the highest quality open source storage stack on the available
today. 

--nab

