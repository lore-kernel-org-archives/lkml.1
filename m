Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbXJWKrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbXJWKrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXJWKrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:47:24 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9953 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXJWKrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:47:24 -0400
Date: Tue, 23 Oct 2007 12:45:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       vladislav.yasevich@hp.com, sri@us.ibm.com
Subject: Re: [PATCH 06/10] [SG] Update net/ to use sg helpers
Message-ID: <20071023104557.GH5059@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-7-git-send-email-jens.axboe@oracle.com> <200710231244.22189.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710231244.22189.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Christian Borntraeger wrote:
> Fix sctp compile
> 
> sctp fails to compile with 
> net/sctp/sm_make_chunk.c: In function 'sctp_pack_cookie':
> net/sctp/sm_make_chunk.c:1516: error: implicit declaration of function 'sg_init_table'
> net/sctp/sm_make_chunk.c:1517: error: implicit declaration of function 'sg_set_page'
> 
> use the proper include file.
> 
> SCTP maintainers Vlad Yasevich and Sridhar Samudrala  are CCed.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Looks good, thanks!

-- 
Jens Axboe

