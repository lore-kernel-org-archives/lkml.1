Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYDGKSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYDGKSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYDGKR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:17:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:46597 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbYDGKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tKL6+K6I0SJ6RjbSb36CvSbkodblp0pf+0TGIvuF+jrIYAMXKA4QKA6C2xazG8KWuZ11DLede0NhIkXRHwl13g1U/yXAjPzeRXPoUrBVbcQAS8Z4xNY3Lb42J7tGgd0rZXVl/aKI3b6x2WMmWn/v8x3bTO+IrwYG6CG0obe/eVc=
Message-ID: <84144f020804070317j4af69036q9801c288ba9ecac4@mail.gmail.com>
Date: Mon, 7 Apr 2008 13:17:54 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: scsi: fix sense_slab/bio swapping livelock
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Peter Zijlstra" <a.p.ziljstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mpm@selenic.com,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <47F9F266.4090107@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804062359.m36Nx3lA016774@hera.kernel.org>
	 <47F9EAD9.3060103@panasas.com>
	 <Pine.LNX.4.64.0804071248110.30814@sbz-30.cs.Helsinki.FI>
	 <47F9F266.4090107@panasas.com>
X-Google-Sender-Auth: 1b495b950f5a287d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boaz,

On Mon, Apr 7, 2008 at 1:07 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>  Please forgive my ignorance, but what is then the difference between kmem_cache_alloc()
>  and kmalloc?

Constructors, user-defined alignment, and tighter object packing.

On Mon, Apr 7, 2008 at 1:07 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>  would you not agree that sometimes we want to override that sharing of SLOBs?

To be honest, I really don't quite understand your use-case. But as
far as I can tell, it hasn't never been explicitly guaranteed and most
certainly has not been true since the merging of SLOB and more
recently SLUB.

                Pekka
