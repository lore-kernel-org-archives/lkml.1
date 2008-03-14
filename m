Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYCNPzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYCNPzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYCNPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:55:09 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:3808 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYCNPzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:55:08 -0400
Message-ID: <47DA9FD7.1070602@hp.com>
Date: Fri, 14 Mar 2008 11:55:03 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, dgc@sgi.com
Subject: Re: IO CPU affinity test results
References: <47DA6C1E.8010000@hp.com> <20080314123606.GL17940@kernel.dk> <20080314130545.GO17940@kernel.dk> <47DA8078.7060804@hp.com>
In-Reply-To: <47DA8078.7060804@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4-way IA64, better, but not good after 30 runs (in single user mode):

Part  RQ   MIN     AVG     MAX      Dev
----- --  ------  ------  ------  ------
 mkfs 0  18.893  19.429  20.129   0.351
 mkfs 1  18.912  19.347  19.934   0.258

untar 0  17.007  17.538  18.829   0.416
untar 1  16.980  17.329  18.369   0.284

 make 0  22.050  23.000  23.546   0.400
 make 1  22.416  23.141  23.637   0.349

 comb 0  58.138  59.967  61.923   0.793
 comb 1  58.428  59.817  60.750   0.608

 psys 0   7.69%   8.77%   9.93%   0.443
 psys 1   8.47%  14.20%  16.33%   2.566

Better run time w/ rq=1 (only 0.25%) but at a huge cost in %sys. Will do some profiling to see what's up.

Alan
