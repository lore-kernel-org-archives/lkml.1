Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZKWV0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZKWV0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbZKWV0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:26:42 -0500
Received: from fieldses.org ([174.143.236.118]:46697 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbZKWV0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:26:42 -0500
Date: Mon, 23 Nov 2009 16:27:26 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       Greg Banks <gnb@fmeh.org>
Subject: Re: 2.6.31 under "heavy" NFS load.
Message-ID: <20091123212726.GC8534@fieldses.org>
References: <4AF86DE4.5010607@krogh.cc> <20091110184126.GD15000@fieldses.org> <4AF9B994.8040301@krogh.cc> <4B05A91D.1090305@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B05A91D.1090305@krogh.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 09:22:53PM +0100, Jesper Krogh wrote:
> Ok, I still haven't had the "excact same" workload put on the host, but
> it has been running on the patched kernel for 8 days now and I havent
> seen load numbers over 32 while service 1100MB/s over NFS (dd'ing 512
> bytes blocks out of the server from the clients) while doing local disk
> IO for an iowait of ~25% (4 cores sucking what they can). This workload
> is "similar" to the one sending it to load numbers of over 100 earlier.
> 
> So I'm confident that the problem is solved by reverting the patch.

OK, I'm applying the revert for 2.6.33.

--b.
