Return-Path: <linux-kernel-owner+w=401wt.eu-S1762511AbYETWz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762511AbYETWz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934477AbYETWzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:55:05 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:21628 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934991AbYETWzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:55:03 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 18:55:03 EDT
X-YMail-OSG: _mvlphsVM1mbihABZsBxX8dP0ntPOUgQY9eOL1Eykir7fZRCMFt4EgL4lv.5Hrfyldi1VH2Zcv5LiBbVYy8oj6nGTk0Lr7hE8f7W.NquJBKfxSE.SchWzM6dh0vP5mnqd1MsEUN2wu_QjmKT45Yo.TINU7qLjxnBjWcZAa_IM9o-
X-Yahoo-Newman-Property: ymail-3
Subject: LIO-Target Core v3.0.0 imported in k.o git
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Open iSCSI <open-iscsi@googlegroups.com>,
       OpenFabrics-General <general@lists.openfabrics.org>
Cc: nab@kernel.org, Ming Zhang <blackmagic02881@gmail.com>,
       "Ross S. W. Walker" <rwalker@medallion.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Grant Grundler <grundler@google.com>,
       Mike Mazarick <mazarick@bellsouth.net>,
       Bryan Black <bdblinux@gmail.com>, Sig Lange <sig.lange@gmail.com>,
       Hannes Reinecke <hare@suse.de>
Content-Type: text/plain
Date: Tue, 20 May 2008 15:48:17 -0700
Message-Id: <1211323697.14731.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

The LIO-Target Core v3.0.0 tree has been imported from v2.9-STABLE from
Linux-iSCSI.org source tree repositories into kernel.org git, and is
building w/ v2.6.26-rc3.  It can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

I will be continuing the cleanup activies for upstream, which so far has
included the removal of legacy unused engine level mirroring/replication
bits (as we are using LIO-DRBD or LIO-NR1 w/ MD for this now), and a few
LINUX_VERSION_CODE removals.  

[nab@hera lio-core]$ wc -l *.c *.h | tail -n 1
  57879 total

The goal now will be to seperate out the LIO-Target / LIO-Core pieces
for moving the latter upstream initially (eg a working passthrough, and
then v3.0 LIO-Target using traditional iSCSI, then iWARP and iSER.  This
will all be going into the roadmap on Linux-iSCSI.org for reference.

I invite interested parties to have a look, and please contact me on the
LIO-Target devel list, or privately if you would like to get involved
looking at some code that are in line with your
knowledge/interests/projects.

Many thanks for your most valuable of time,

--nab




