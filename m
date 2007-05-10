Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbXEJQ1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbXEJQ1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbXEJQ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:27:16 -0400
Received: from pat.uio.no ([129.240.10.15]:36416 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbXEJQ1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:27:16 -0400
Subject: RE: [PATCH] NLM program ID for user space NLM server
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Menny Hamburger <menny@exanet.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <A6FDE6B975803043804A49F12F49028E0F59D3@hawk.exanet-il.co.il>
References: <A6FDE6B975803043804A49F12F49028E0F59D3@hawk.exanet-il.co.il>
Content-Type: text/plain
Date: Thu, 10 May 2007 12:27:11 -0400
Message-Id: <1178814431.6775.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.5, required=12.0, autolearn=disabled, AWL=-0.469)
X-UiO-Scanned: 0B01ADA2E802D4FBE1764345D2A075D708985140
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -4 maxlevel 200 minaction 2 bait 0 mail/h: 503 total 1649858 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 18:30 +0300, Menny Hamburger wrote:
> The idea in the change was to be able to override NLM_PROGRAM with
> another definition (from our slightly customized build system), so that
> the kernel never tries to register port 100021.

I repeat: The kernel _NEEDS_ to register RPC service 100021 on the
client so that rpc.statd can find it and notify it of server reboots.

Trond

