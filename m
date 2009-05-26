Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbZEZT5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbZEZT5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbZEZT46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:56:58 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:29276 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZEZT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:56:56 -0400
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH] bio-integrity: Copy bip_buf and bip_size in bio_integrity_clone()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090524042035.GF1376@blitiri.com.ar>
	<yq1iqjpg4co.fsf@sermon.lab.mkp.net>
	<20090526020704.GJ1376@blitiri.com.ar>
Date: Tue, 26 May 2009 15:56:39 -0400
In-Reply-To: <20090526020704.GJ1376@blitiri.com.ar> (Alberto Bertogli's
	message of "Mon, 25 May 2009 23:07:04 -0300")
Message-ID: <yq1iqjnbpu0.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A1C497A.020D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Alberto" == Alberto Bertogli <albertito@blitiri.com.ar> writes:

Alberto> The case I was thinking about was something like a filesystem
Alberto> calling bio_integrity_get_tag() on a cloned bio, 

Filesystems never see cloned bios.


Alberto>  - What would be a decent name to use in struct blk_integrity
Alberto>    for a module such as mine? Is LINUX-DMCSUM-V0-CCITT
Alberto>    reasonable?

Yeah.  Doesn't matter much, really.  The original intent was simply to
capture the variations in the (hardware) protocols .


Alberto>  - How can I test the tag functions? From a quick grep I found
Alberto>    no in-tree users of bio_integrity_get/set_tag().

There are no users yet.

-- 
Martin K. Petersen	Oracle Linux Engineering
