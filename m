Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYKAUYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYKAUYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 16:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYKAUYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 16:24:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:23390 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYKAUYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 16:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=b5r7HcNqofcKlj53/HJwvgurhXqRcFylEcVulk+9woNHEE9rhxnJEOfq+c+Raxb8WJ
         pVswWcjxx75Gt88pbFlf5rNhswozwWYSnnFUBTGVDqbomth8pAJuetx2x4ndV9j7a4ba
         oPNl94JFYvA8b2kvVZvs5fz8zqtSAaqz5nIYM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3 __log_wait_for_space: no transactions
Date: Sat, 1 Nov 2008 21:21:29 +0100
User-Agent: KMail/1.9.10
Cc: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081101163829.GD8134@mit.edu> <20081101171042.GE8134@mit.edu>
In-Reply-To: <20081101171042.GE8134@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811012121.29534.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 01 November 2008, Theodore Tso wrote:
> BTW, I've opened a Bugzilla entry to track this as a 2.6.27 regression:
> 
>      http://bugzilla.kernel.org/show_bug.cgi?id=11935

I've just got hit by this bug the second time (first with next-20081030,
now with next-20081031) -- both times it happened during kernel build
(I'm chasing some other kernel regression).

[ The parition size is 20GB, the journal size is 32MB (default size). ]

I applied the proposed fix and will keep you informed how it goes
(still many kernel builds awaits me IOT pinpoint the other issue).

Thanks,
Bart
