Return-Path: <linux-kernel-owner+w=401wt.eu-S1423491AbXD3SJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423491AbXD3SJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423511AbXD3SJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:09:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42173 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423494AbXD3SJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:09:04 -0400
Date: Mon, 30 Apr 2007 23:46:59 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Christoph Hellwig <hch@infradead.org>, Paul Jackson <pj@sgi.com>,
       menage@google.com, akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 0/9] Containers (V9): Generic Process Containers
Message-ID: <20070430181659.GI24350@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070427104607.252541000@menage.corp.google.com> <20070429023721.53f249b9.pj@sgi.com> <20070430171225.GH24350@in.ibm.com> <20070430172352.GA8567@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430172352.GA8567@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 06:23:52PM +0100, Christoph Hellwig wrote:
> Umm, no - please naje two versions with and without the lock.

Ok this patch may not be necessary (given Paul's observation that
read_lock will suffice in update_nodemask).

> Also Please fix up the codingstyle, the { belongs onto a line of it's own.

Paul, I suspect that there are a number of Codingstyle related changes you
may need to address in your next version (including the one pointed by 
Christoph) 


-- 
Regards,
vatsa
