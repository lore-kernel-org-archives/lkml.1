Return-Path: <linux-kernel-owner+w=401wt.eu-S1767302AbXECBbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767302AbXECBbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 21:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767308AbXECBbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 21:31:55 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52244
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767302AbXECBby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 21:31:54 -0400
Date: Wed, 2 May 2007 18:31:21 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel@vger.kernel.org
Subject: scheduling oddity on 2.6.20.3 stock
Message-ID: <Pine.LNX.4.64.0705021826560.5342@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I needed to recompress some files from .bz2 to .gz so I setup a script to 
do

bunzip2 -c $file.bz2 |gzip -9 >$file.gz

I expected that the two CPU heavy processes would end up on different 
cpu's and spend a little time shuffling data between the two cpu's on a 
system (dual core opteron)

however, instead what I find is that each process is getting 50% of one 
cpu while the other cpu is 97% idle.

David Lang
