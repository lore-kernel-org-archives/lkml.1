Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbZFYQHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbZFYQHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZFYQHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:07:22 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:32411 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbZFYQHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:07:21 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <200906250904.57149.elendil@planet.nl>
	<yq1tz24qqaj.fsf@sermon.lab.mkp.net>
	<200906251748.45475.elendil@planet.nl>
Date: Thu, 25 Jun 2009 12:05:47 -0400
In-Reply-To: <200906251748.45475.elendil@planet.nl> (Frans Pop's message of
	"Thu, 25 Jun 2009 17:48:44 +0200")
Message-ID: <yq1prcsqox0.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4A43A05E.0037:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Frans" == Frans Pop <elendil@planet.nl> writes:

Frans> I've just also tested rc1 in the Hercules s390 emulator, and I
Frans> get exactly the same there on a virtual dasd disk:

Frans> dasd-eckd 0.0.0121: New DASD 3390/02 (CU 3990/02) with 1113
Frans> cylinders, 15 heads, 224 sectors dasd-eckd 0.0.0121: DASD with 4
Frans> KB/block, 801360 KB total size, 48 KB/track, compatible disk

DASD uses 4KB blocks so that makes more sense.

The SATA thing is weird.

-- 
Martin K. Petersen	Oracle Linux Engineering
