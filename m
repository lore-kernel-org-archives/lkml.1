Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbZJQHYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbZJQHYN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 03:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZJQHYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 03:24:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56819 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZJQHYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 03:24:12 -0400
Message-ID: <4AD97107.6040001@cs.helsinki.fi>
Date: Sat, 17 Oct 2009 10:23:51 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com> <alpine.DEB.1.10.0910161249100.6120@gentwo.org> <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

David Rientjes wrote:
> On a semi-related topic, it would have been nice to isolate all statistic 
> files to its own directory: /sys/kernel/slab/kmalloc-256/stats/..., for 
> example.  It would have made collecting (and now clearing) all statistics 
> much easier since userspace wouldn't need a predefined list of stat file 
> names to scan.  I wonder if Pekka would allow them to be moved...

It's a non-production configuration option and the only known user of 
the ABI is in slabinfo.c so maybe we can just go ahead and do that. 
Alternatively, I think we can preserve the current ABI with symbolic 
links in sysfs?

			Pekka
