Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbZFLOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbZFLOeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbZFLOeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:34:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37572 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbZFLOeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:34:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface (v2)
References: <4A3075B2.9040208@ct.jp.nec.com>
	<20090611110903.GO11363@kernel.dk>
	<x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>
	<20090612133014.GK11363@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 12 Jun 2009 10:33:59 -0400
In-Reply-To: <20090612133014.GK11363@kernel.dk> (Jens Axboe's message of "Fri,
	12 Jun 2009 15:30:14 +0200")
Message-ID: <x49ski5v7vs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Thu, Jun 11 2009, Jeff Moyer wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>> Is blk_rq_unprep_clone really the best name?
>>           ^^^^^^
>
> Probably not, but I'm not very good at coming up with elegant names.
> Your email should have included a new suggestion :-)

Fair enough.  ;)

>  - blk_rq_unprep_clone(struct request *clone)
>      * Frees cloned bios from the clone request.

Why not blk_rq_free_clone?

-Jeff
