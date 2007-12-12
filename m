Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbXLLMzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbXLLMzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 07:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXLLMz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 07:55:26 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:45695 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292AbXLLMzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 07:55:25 -0500
Subject: Re: [PATCH 27/30] blk_end_request: changing scsi (take 4)
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, bharrosh@panasas.com
In-Reply-To: <20071211.175209.10128473.k-ueda@ct.jp.nec.com>
References: <20071211.175209.10128473.k-ueda@ct.jp.nec.com>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 07:55:16 -0500
Message-Id: <1197464116.4203.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-11 at 17:52 -0500, Kiyoshi Ueda wrote:
> This patch converts scsi mid-layer to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
> 
> As a result, the interface of internal function, scsi_end_request(),
> is changed.

This looks fine, as far as it goes.

One of the things that might actually be useful in future is as well as
communicating the error, the ability to say more information about what
happened.  For instance dm-mp needs to know whether the error is
transport or device related (the former being retryable on a different
path).

James


