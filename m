Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZITVAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZITVAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZITVAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:00:40 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:50129 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZITVAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:00:40 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] [PATCH 1/3] block: Add blk_queue_copy_limits()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4AB3B43D.9000802@ce.jp.nec.com>
	<yq1eiq46ohz.fsf@sermon.lab.mkp.net> <4AB4F74E.7000908@ce.jp.nec.com>
Date: Sun, 20 Sep 2009 17:00:24 -0400
In-Reply-To: <4AB4F74E.7000908@ce.jp.nec.com> (Jun'ichi Nomura's message of
	"Sun, 20 Sep 2009 00:22:54 +0900")
Message-ID: <yq1k4zt5o2f.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AB697EB.00AD:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:

Jun'ichi> Umm, with this, BLK_DEF_MAX_SECTORS becomes upper bound of
Jun'ichi> max_hw_sectors and the values of underlying devices are not
Jun'ichi> propagated to the stacking devices.  

Well, max_sectors is already bounded by this.  max_hw_sectors only
really matters for PC commands, so I'm not sure it's a big deal for
DM. But I guess we could set the default max_hw_sectors to -1.

I'm just trying to avoid these scattered if-0-set-it-to-something-else
cases.  I'd much rather have the defaults do the right thing.

-- 
Martin K. Petersen	Oracle Linux Engineering
