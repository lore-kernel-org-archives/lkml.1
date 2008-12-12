Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYLLNuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYLLNuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbYLLNuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:50:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46339 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127AbYLLNuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:50:24 -0500
Message-ID: <49426C16.6040108@redhat.com>
Date: Fri, 12 Dec 2008 08:50:14 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jean Delvare <khali@linux-fr.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
References: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081211113646.GI23742@kernel.dk> <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081212075844.GH23742@kernel.dk>
In-Reply-To: <20081212075844.GH23742@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:

> Me neither, lets ask the originator of the patch. Rik, why is
> unevictable lru an option?

I think we had some reasons to keep it as a separate config
option during development, but nowadays we might as well
put it all just under CONFIG_SWAP...

-- 
All rights reversed.
