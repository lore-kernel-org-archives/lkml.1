Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbYHRTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbYHRTVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYHRTVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:21:04 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:51891 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYHRTVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:21:03 -0400
Subject: Re: NFS regression?  Odd delays and lockups accessing an NFS
	export.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, bfields@fieldses.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 15:20:58 -0400
Message-Id: <1219087258.7192.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 72F64AA66D3FE4DA16DA8246327FD9EA56B7A482
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 2 total 20 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 12:02 +1000, Grant Coady wrote:
> Hi there,
> 
> I've been using NFS here for years, lately there's something odd going on 
> since about a month or so.  Previously reported last month:
> http://www.gossamer-threads.com/lists/linux/kernel/951419?page=last
> 
> Now with 2.6.27-rc3 on one of the client boxes I get a complete stall 
> at odd times when accessing the server's exported directory, cannot 
> see a pattern to it.  Eventually recovers after a Ctrl-C.  Nothing in 
> the server or client log files.  Not easy to reproduce either.
> 
> The server runs 2.6.26.2 at the moment.
> 
> Server config, etc: http://bugsplatter.id.au/kernel/boxen/deltree/
> Client config, etc: http://bugsplatter.id.au/kernel/boxen/pooh/

Please try to reproduce the hang, then do

	echo 0 >/proc/sys/sunrpc/rpc_debug

and send the output from 'dmesg'...

Cheers
  Trond

