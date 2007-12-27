Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbXL0AZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbXL0AZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 19:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXL0AYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 19:24:52 -0500
Received: from ozlabs.org ([203.10.76.45]:50949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXL0AYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 19:24:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 7/7] sg_ring: convert core ATA code to sg_ring.
Date: Thu, 27 Dec 2007 11:24:31 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191838.27363.rusty@rustcorp.com.au> <47721294.7030401@gmail.com>
In-Reply-To: <47721294.7030401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271124.31511.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 December 2007 19:36:36 Tejun Heo wrote:
> It would be better to build upon sg chaining as we already have it.  I
> think it can be made much easier with a bit more safe guards,
> generalization and some helpers.

Hi Tejun,

    I did this work to replace sg chaining.  The current chaining code gives 
us longer sgs, and (if used carefully) the ability to append in some 
circumstances.  But it's clumsy, and we can do better.  This is my attempt.

    I understand that people are experiencing whiplash from the idea of 
another change just after the sg chaining changes which have already gone in.  

    At the very least, I think I'll have to come up with a better transition 
plan for SCSI drivers, rather than trying to convert them all at once... In 
theory, sg chaining can be done through the sg ring arrays, but that's pretty 
horrible.

Cheers,
Rusty.
