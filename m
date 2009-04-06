Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZDFMKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZDFMKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbZDFMK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:10:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:65191 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZDFMK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:10:26 -0400
Message-ID: <49D9F0F0.9080206@vlnb.net>
Date: Mon, 06 Apr 2009 16:09:20 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Joel Becker <joel.becker@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Ming Zhang <blackmagic02881@gmail.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>,
       Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [RFC PATCH 0/19] Target_Core_Mod/ConfigFS v3.0 for v2.6.30
References: <1238904091.4250.741.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1238904091.4250.741.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX185+49ucVD98orEN8OoHLAMfxx1Whqhbr5PxB+
 BSDbHbr5/oY9Hm0snnu8tHe1pNRd2JIiGan8qfNvCIkrFjMqrY
 x+uDEDB8UcymZWMLgwuuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger, on 04/05/2009 08:01 AM wrote:
> Greetings all,
> 
> I am very proud to announce the first RFC and submission for review of
> Target_Core_Mod/ConfigFS v3.0 for v2.6.30.
> 
> Target_Core_Mod is a generic target engine and ConfigFS enabled
> infrastructure that provides access to the export server side resources
> from Linux/SCSI, Linux/BLOCK and Linux/FILEIO (using buffered I/O)
> subsytems to target mode storage fabric modules (like the LIO-Target
> v3.0 fabric module).  It does complete SPC-3 control emulation on top of
> Linux/BLOCK and Linux/FILEIO objects, and does a SCSI passthrough (with
> intelligent max_sectors handling) for Linux/SCSI objects.
> 
> Target_Core_Mod/ConfigFS is the next generation version of the
> LIO-Target v2.9 codebase that is completely SCSI fabric module
> independent.  The configuration plane has been ported from our legacy
> LIO IOCTl control path in v2.9, and is now 100% upstream ConfigFS
> infrastructure clean for v3.0.
> 
> Target_Core_Mod/ConfigFS also contains a number of SCSI fabric features
> that you will not find in any other open source Linux-SCSI or
> Linux-iSCSI target implementation.  These now include SPC-3 compliant
> persistent reservation support that is passing complete domain
> validation from multiple client environments (RHEL SCSI fencing and MSFT
> Cluster 2008), Asymmetric Logical Unit Assignment (Linux scsi_dh_alua
> and MPxIO on OpenSolaris clients), VPD/WWN information emulation and
> SCSI MIBs to name the most interesting ones.

Nicholas,

What is the ultimate goal of Target_Core_Mod/ConfigFS? Is it to replace 
currently kernel's target subsystem STGT? If yes, what advantages 
Target_Core_Mod/ConfigFS has over STGT, which can justify such a move?

For convenience of all interested people I summarized comparison between 
STGT and other existing SCSI targets for Linux, including 
Target_Core_Mod/ConfigFS (LIO v3.0), in 
http://scst.sourceforge.net/comparison.html. If you don't like anything 
in this comparison, we can discuss it.

Vlad

