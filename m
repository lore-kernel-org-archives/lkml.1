Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbZG0O3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbZG0O3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZG0O3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:29:49 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:45389 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZG0O3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:29:48 -0400
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>
	<yq1hbwykj80.fsf@sermon.lab.mkp.net>
	<20090727020611.GC3711@parisc-linux.org>
	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com>
Date: Mon, 27 Jul 2009 10:29:21 -0400
In-Reply-To: <4A6D64DC.3020001@panasas.com> (Boaz Harrosh's message of "Mon,
	27 Jul 2009 11:27:08 +0300")
Message-ID: <yq1ocr66vy6.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A6DB9C4.0165:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> I don't understand. The device in question breaks when we try to
Boaz> read a page that it reported it supports?

No.  The USB-ATA bridge in question locks up when we send it an INQUIRY
with EVPD=1.  I.e. when we try to get a list of pages. 0xB0 and 0xB1 are
not even in play here.

-- 
Martin K. Petersen	Oracle Linux Engineering
