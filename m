Return-Path: <linux-kernel-owner+w=401wt.eu-S1764910AbXFRTJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764910AbXFRTJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764433AbXFRTJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:09:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:47394 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764092AbXFRTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OUyM41GkCDECgPYlH0Q/O5d42YKprMw6DX2u5jE24we1jINwlj0rKvbSr61vqOJpYAPlzQU+1EVIZDnWKtgGg5vBl8ldxK3mRKjCvBOU8wy51EJ/OVUG26zaPcR+nFs8CXzhj6Sbq1O2v53J5IE93SHee7eBjg5mPKJgNEvK3zE=
Message-ID: <6bffcb0e0706181209p49f4ae86xce5418b7c9b3edbb@mail.gmail.com>
Date: Mon, 18 Jun 2007 21:09:04 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 00/26] Current slab allocator / SLUB patch queue
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
In-Reply-To: <Pine.LNX.4.64.0706181159430.1896@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <46767346.2040108@googlemail.com>
	 <Pine.LNX.4.64.0706180936280.4751@schroedinger.engr.sgi.com>
	 <6bffcb0e0706181038j107e2357o89c525261cf671a@mail.gmail.com>
	 <Pine.LNX.4.64.0706181102280.6596@schroedinger.engr.sgi.com>
	 <6bffcb0e0706181158l739864e0t6fb5bc564444f23c@mail.gmail.com>
	 <Pine.LNX.4.64.0706181159430.1896@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 18 Jun 2007, Michal Piotrowski wrote:
>
> > Still the same.
>
> Is it still exactly the same strack trace?

Not exactly the same
[<c0480d4b>] list_locations+0x257/0x2ad
is the only difference

 l *list_locations+0x257
0xc1080d4b is in list_locations (mm/slub.c:3655).
3650                                    l->min_pid);
3651
3652                    if (num_online_cpus() > 1 && !cpus_empty(l->cpus) &&
3653                                    n < PAGE_SIZE - n - 60) {
3654                            n += sprintf(buf + n, " cpus=");
3655                            n += cpulist_scnprintf(buf + n,
PAGE_SIZE - n - 50,
3656                                            l->cpus);
3657                    }
3658
3659                    if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&


> There could be multiple issue
> if we overflow PAGE_SIZE there.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
