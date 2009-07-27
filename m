Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbZG0PKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbZG0PKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZG0PKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:10:45 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:44610 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZG0PKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:10:45 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>
	<yq1hbwykj80.fsf@sermon.lab.mkp.net>
	<20090727020611.GC3711@parisc-linux.org>
	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com>
	<yq1ocr66vy6.fsf@sermon.lab.mkp.net>
	<20090727145048.GF3711@parisc-linux.org>
Date: Mon, 27 Jul 2009 11:10:15 -0400
In-Reply-To: <20090727145048.GF3711@parisc-linux.org> (Matthew Wilcox's
	message of "Mon, 27 Jul 2009 08:50:48 -0600")
Message-ID: <yq1k51u6u20.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A6DC35C.018D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> Tarkan didn't say it locked up.  He said it returned:

Matthew> root@tarkane:~# sg_inq -e /dev/sdb VPD INQUIRY: extended
Matthew> INQUIRY data page

Matthew> inquiry: transport: Host_status=0x05 [DID_ABORT]
Matthew> Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]

Matthew>     inquiry: failed, res=-1

Look further back in the original thread.  Sending the extended inquiry
causes a USB reset.

-- 
Martin K. Petersen	Oracle Linux Engineering
