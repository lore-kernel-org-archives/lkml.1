Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbXFDPmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbXFDPmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbXFDPmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:42:18 -0400
Received: from pat.uio.no ([129.240.10.15]:46027 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914AbXFDPmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:42:17 -0400
Subject: Re: slow open() calls and o_nonblock
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Aaron Wiebe <epiphani@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e7ca40f70706040720k48aae8efg7a4997ce1d6f2450@mail.gmail.com>
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	 <e7ca40f70706040720k48aae8efg7a4997ce1d6f2450@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 11:42:06 -0400
Message-Id: <1180971726.17737.36.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.124)
X-UiO-Scanned: 1CD9113152E98DBD1C486075C051A6266C95F655
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 819 total 2154507 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 10:20 -0400, Aaron Wiebe wrote:
> I understand, but this is exactly the situation that I'm complaining
> about.  There is no functionality to provide a nonblocking open - no
> ability to come back around and retry a given open call.

So exactly how would you expect a nonblocking open to work? Should it be
starting I/O? What if that involves blocking? How would you know when to
try again?

  Trond

