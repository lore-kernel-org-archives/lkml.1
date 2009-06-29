Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZF2DWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZF2DWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZF2DWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:22:00 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:29685 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZF2DV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:21:59 -0400
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4A4472DF.1050900@turknet.net.tr>
Date: Sun, 28 Jun 2009 23:21:36 -0400
In-Reply-To: <4A4472DF.1050900@turknet.net.tr> (Tarkan Erimer's message of
	"Fri, 26 Jun 2009 10:03:59 +0300")
Message-ID: <yq1zlbrn2rj.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A483343.00B5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tarkan" == Tarkan Erimer <tarkan.erimer@turknet.net.tr> writes:

Tarkan> Hi, I just tried to plug a "Western Digital, My Book Series" USB
Tarkan> disk on 2.6.31-rc1. But, it failed to recognize it by saying
Tarkan> "READ CAPACITY failed". The same disk works fine with =<
Tarkan> 2.6.30.

Can you please mail us the output of...

# sg_inq /dev/sdb
# sg_readcap /dev/sdb
# sg_readcap -l /dev/sdb

... for that WD drive?

You may have to install the sg3_utils package.

-- 
Martin K. Petersen	Oracle Linux Engineering

