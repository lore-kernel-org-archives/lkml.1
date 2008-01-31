Return-Path: <linux-kernel-owner+w=401wt.eu-S1764893AbYAaDdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764893AbYAaDdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbYAaDdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:33:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50732 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYAaDdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:33:24 -0500
Date: Thu, 31 Jan 2008 03:33:20 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Denis V. Lunev" <den@openvz.org>
Cc: trond.myklebust@fys.uio.no, hch@infradead.org,
       linux-kernel@vger.kernel.org, xemul@openvz.org, devel@openvz.org
Subject: Re: [PATCH] [NFS]: Lock daemon start/stop rework.
Message-ID: <20080131033320.GA15067@infradead.org>
References: <1201693294-11460-1-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201693294-11460-1-git-send-email-den@openvz.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 02:41:34PM +0300, Denis V. Lunev wrote:
> The pid of the locking daemon can be substituted with a task struct
> without a problem. Namely, the value if filled in the context of the lockd
> thread and used in lockd_up/lockd_down.
> 
> It is possible to save task struct instead and use it to kill the process.
> The safety of this operation is guaranteed by the RCU, i.e. task can't
> disappear without passing a quiscent state.

We have a patch series pending on the nfs list that does this plus a lot
more in the area.

