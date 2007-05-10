Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbXEJNjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbXEJNjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbXEJNjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:39:07 -0400
Received: from pat.uio.no ([129.240.10.15]:51437 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbXEJNjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:39:05 -0400
Subject: RE: [PATCH] NLM program ID for user space NLM server
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Menny Hamburger <menny@exanet.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <A6FDE6B975803043804A49F12F49028E0F59CC@hawk.exanet-il.co.il>
References: <A6FDE6B975803043804A49F12F49028E0F59CC@hawk.exanet-il.co.il>
Content-Type: text/plain
Date: Thu, 10 May 2007 09:39:00 -0400
Message-Id: <1178804340.6481.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.167)
X-UiO-Scanned: A297C8C88BBEE42921C8F64288F35040C09195C9
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 1359 total 1645806 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 13:59 +0300, Menny Hamburger wrote:
> Hi,
> 
> We have a our own userland NFSD and NLM service running that implement
> all the NLM/NFS functionality.
> We do not want to modify the way the client does his mounts.
> 
> M.

The client needs to have lockd running (as service 100021) in order to
allow the NSM daemon to notify it of server reboots.

Trond

