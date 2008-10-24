Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbYJXSJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbYJXSJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYJXSJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:09:29 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:38723 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbYJXSJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:09:28 -0400
Subject: Re: High load in 2.6.27, NFS / rpcauth_lookup_credcache()?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <20081024083913.GA15197@squirrel.roonstrasse.net>
References: <20081022091207.GA12996@squirrel.roonstrasse.net>
	 <20081023123628.GA18549@squirrel.roonstrasse.net>
	 <1224773745.7625.4.camel@localhost>
	 <20081024083913.GA15197@squirrel.roonstrasse.net>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 14:09:23 -0400
Message-Id: <1224871763.22672.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, MISSING_SUBJECT=0.001,NO_RECEIVED=-0.001, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8CDBD97A6F43869247DA6676D8B4E05F04CD8806
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 137 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 10:39 +0200, Max Kellermann wrote:
> On 2008/10/23 16:55, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > Can you add a '-v' to the rpc.gssd daemon startup line? I'd like to see
> > how often you are creating new gss contexts.
> 
> There is no rpc.gssd running on any of these servers, we're using
> plain NFSv3 without (protocol based) authentication.  Do you want me
> to start it anyway?

Sorry. I misread your email. I read it as saying that you had krb5
enabled on your mountpoint, but what you really said was just that you
have compiled up the module.

OK, could you please describe your environment a bit. Do you have lots
of different users logged in at the same time, or do you perhaps use
newgrp or su to switch uid/gids a lot on your processes?
I'm trying to see if there might be a reason for the lookup in the
credcache being such a heavy duty operation in your setup.

Cheers
  Trond

