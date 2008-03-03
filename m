Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYCCS1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYCCS1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYCCS1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:27:14 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35967 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYCCS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:27:12 -0500
Subject: Re: [PATCH] block: separate out padding from alignment
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <htejun@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org,
       jens.axboe@oracle.com, efault@gmx.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com
In-Reply-To: <47CB9654.2000109@gmail.com>
References: <47C8F4FC.1040505@gmail.com>	<20080302235223X.tomof@acm.org>
	 <47CB6508.3040206@gmail.com>
	 <20080303125940T.fujita.tomonori@lab.ntt.co.jp>
	 <47CB79E9.8000505@gmail.com> <47CB95C2.40309@gmail.com>
	 <47CB9654.2000109@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 12:27:07 -0600
Message-Id: <1204568827.3043.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 15:10 +0900, Tejun Heo wrote:
> Block layer alignment was used for two different purposes - memory
> alignment and padding.  This causes problems in lower layers because
> drivers which only require memory alignment ends up with adjusted
> rq->data_len.  Separate out padding such that padding occurs iff
> driver explicitly requests it.

This puts the libsas SMP handler back into a working state again.

Thanks,

James


