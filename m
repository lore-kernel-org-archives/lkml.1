Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbYJaORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbYJaORP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYJaOQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:16:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15977 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYJaOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:16:58 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] [PATCH] Add gfp_mask to bio_integrity_clone()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <490942D4.3070504@ce.jp.nec.com>
Date: Fri, 31 Oct 2008 10:16:47 -0400
In-Reply-To: <490942D4.3070504@ce.jp.nec.com> (Jun'ichi Nomura's message of "Thu\, 30 Oct 2008 14\:15\:00 +0900")
Message-ID: <yq1hc6s3l4g.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:

Jun'ichi> What do you think about adding gfp_mask parameter to
Jun'ichi> bio_integrity_clone() like the attached patch?

Jun'ichi> It also seems natural to inherit gfp_mask from bio_clone
Jun'ichi> when bio_integrity_clone is called from it.  Since
Jun'ichi> bio_clone() is the only caller of bio_integrity_clone() in
Jun'ichi> 2.6.28-rc2 and all in-tree callers of bio_clone() are using
Jun'ichi> GFP_NOIO, the patch does nothing other than changing the
Jun'ichi> interface.

Looks good to me.  I'll update the non-multipath DM bits accordingly.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
