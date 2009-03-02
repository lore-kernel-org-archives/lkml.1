Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZCBUi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZCBUi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZCBUiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:38:16 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36808 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZCBUiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:38:15 -0500
Message-ID: <49AC437F.7020001@cs.wisc.edu>
Date: Mon, 02 Mar 2009 14:37:19 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Grant Grundler <grundler@google.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mike.miller@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, hare@novell.com, iss_storagedev@hp.com,
       iss.sbteam@hp.com
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
References: <20090227230927.GA21377@roadking.ldev.net> <20090302153246A.fujita.tomonori@lab.ntt.co.jp> <da824cf30903020919q2d3496e6sb5a253b0acba681a@mail.gmail.com> <49AC237A.7060005@cs.wisc.edu> <20090302183649.GB11787@kernel.dk> <49AC4293.4030902@cs.wisc.edu>
In-Reply-To: <49AC4293.4030902@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Christie wrote:
> iscsi also needs the unique tag and then it needs the 
> blk_map_queue_find_tag functionality too. iscsi needs the lookup and tag 
> for host/transport level commands that do not have a scsi 
> command/request. The tag value has to be unique accross the 
> host/transport

I mean that the tag needs to be unique for scsi/block commands and 
transport commands for each host. So a scsi command and a transport 
command cannot both have tag X.

