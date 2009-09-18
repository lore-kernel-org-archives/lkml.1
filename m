Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZIRQNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZIRQNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZIRQNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:13:35 -0400
Received: from fifo99.com ([67.223.236.141]:32808 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbZIRQNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:13:35 -0400
Subject: Re: [PATCH 2/3] block: Rename trace_block_remap to
 trace_block_bio_remap
From: Daniel Walker <dwalker@fifo99.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
In-Reply-To: <4AB3A393.5000709@ce.jp.nec.com>
References: <4AB3A393.5000709@ce.jp.nec.com>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 09:13:45 -0700
Message-Id: <1253290425.7060.37.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 00:13 +0900, Jun'ichi Nomura wrote:
>   **/
> -static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
> -                                      dev_t dev, sector_t from)
> +static void blk_add_trace_bio_remap(struct request_queue *q, struct bio
> *bio,
> +                                   dev_t dev, sector_t from)
>  {

You might need to resubmit this, you have some line wrapping in the
above lines.. Your should be able to set the patch part of the email to
"preformatted" , you don't want your mailer line wrapping .. (even
better just use git-format-patch and git-send-email) ..

Daniel

