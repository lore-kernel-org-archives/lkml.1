Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXBSVH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXBSVH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbXBSVH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:07:59 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:58302 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbXBSVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:07:58 -0500
In-Reply-To: <20070219204703.GB31205@kvack.org>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net> <20070219204703.GB31205@kvack.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <16FF8A01-2020-45D8-AB4D-162345CB2653@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Leonid Ananiev <leonid.i.ananiev@intel.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Mon, 19 Feb 2007 13:07:26 -0800
To: Benjamin LaHaise <bcrl@kvack.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>   I
> *think* the patch is right, but picking the changes to the code and  
> watching
> its movement at the same time is making my head spin.

Really?  The only things that changed are the assignment from iocb- 
 >res (after testing pending_err) instead of the 'res' argument and  
the dprintk.

But, uh, sure.  If it's a burden I can respin it as two patches.   
Here they come!

- z
