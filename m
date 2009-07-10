Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZGJITH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZGJITH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZGJISx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:18:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49181 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZGJISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:18:52 -0400
Date: Fri, 10 Jul 2009 10:18:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: no need to keep track of busy_rt_queues
Message-ID: <20090710081851.GY23611@kernel.dk>
References: <20090709204759.GF30832@redhat.com> <20090709205108.GG30832@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709205108.GG30832@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09 2009, Vivek Goyal wrote:
> Resending as had forgotten to put "[PATCH]" in subject line.
> 
> o Get rid of busy_rt_queues infrastructure. Looks like it is redundant.
> 
> o Once an RT queue gets request it will preempt any of the BE or IDLE queues
>   immediately. Otherwise this queue will be put on service tree and scheduler
>   will anyway select this queue before any of the BE or IDLE queue. Hence
>   looks like there is no need to keep track of how many busy RT queues are
>   currently on service tree. 

Looks good, I'll queue this up for 2.6.32.

-- 
Jens Axboe

