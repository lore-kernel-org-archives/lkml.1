Return-Path: <linux-kernel-owner+w=401wt.eu-S1761730AbXH3Ocb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761730AbXH3Ocb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbXH3OcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:32:21 -0400
Received: from pat.uio.no ([129.240.10.15]:60061 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062AbXH3OcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:32:20 -0400
Subject: Re: NFS4 authentification / fsuid
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1188484155.6755.38.camel@heimdal.trondhjem.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
	 <1188484155.6755.38.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 10:32:17 -0400
Message-Id: <1188484337.6755.41.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.092)
X-UiO-Scanned: 7A2225C9D7C6D3690B93F74ED92993FBB9A9A0DD
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 754 total 3566799 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 10:29 -0400, Trond Myklebust wrote:
> We've got people working on fixing this problem using David Howells'
> keyrings, but it will probably be a while until we've solved all the
> upcall issues, and it will probably take even longer to push the
> kerberos changes back to the official MIT etc distros.

BTW: even when this task is done, a creative root can still find ways to
subvert the security (he can read /dev/mem, replace the kernel with a
compromised one, ....). The bottom line is that if you can't trust root,
don't even log in.

Trond

