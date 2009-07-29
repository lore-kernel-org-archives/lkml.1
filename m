Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZG2FsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZG2FsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 01:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZG2FsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 01:48:09 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:48044 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZG2FsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 01:48:08 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: drbd tree build failure
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090729152938.791a81c3.sfr@canb.auug.org.au>
Date: Wed, 29 Jul 2009 01:47:48 -0400
In-Reply-To: <20090729152938.791a81c3.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Wed, 29 Jul 2009 15:29:38 +1000")
Message-ID: <yq1prbk59bv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A6FE287.009C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Stephen" == Stephen Rothwell <sfr@canb.auug.org.au> writes:

Stephen> drivers/block/drbd/drbd_nl.c: In function
Stephen> 'drbd_setup_queue_param': drivers/block/drbd/drbd_nl.c:707:
Stephen> error: implicit declaration of function
Stephen> 'blk_queue_stack_limits'

We've decided to keep blk_queue_stack_limits as a wrapper to ease the
transition.  I sent Jens a patch earlier today that does this.

-- 
Martin K. Petersen	Oracle Linux Engineering
