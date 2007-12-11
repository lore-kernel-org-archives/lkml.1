Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbXLKW7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbXLKW7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXLKW71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:59:27 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:57416 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXLKW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:59:26 -0500
Message-ID: <fa686aa40712111459k28a9bd96r484d8d9317c11671@mail.gmail.com>
Date: Tue, 11 Dec 2007 15:59:25 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 20/30] blk_end_request: changing xsysace (take 4)
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
In-Reply-To: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>
X-Google-Sender-Auth: 4dc8d2aadc495bcf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/07, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> This patch converts xsysace to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
>
> xsysace is a little bit different from "normal" drivers.
> xsysace driver has a state machine in it.
> It calls end_that_request_first() and end_that_request_last()
> from different states. (ACE_FSM_STATE_REQ_TRANSFER and
> ACE_FSM_STATE_REQ_COMPLETE, respectively.)
>
> However, those states are consecutive and without any interruption
> inbetween.
> So we can just follow the standard conversion rule (b) mentioned in
> the patch subject "[PATCH 01/30] blk_end_request: add new request
> completion interface".
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
