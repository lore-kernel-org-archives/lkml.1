Return-Path: <linux-kernel-owner+w=401wt.eu-S935045AbXFFUDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935045AbXFFUDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbXFFUDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:03:35 -0400
Received: from pat.uio.no ([129.240.10.15]:57910 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017AbXFFUDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:03:34 -0400
Subject: Re: kmap_atomic in 2.6.20.x
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <5d96567b0706061003r462c324i733ad3698ac3d90c@mail.gmail.com>
References: <5d96567b0706061003r462c324i733ad3698ac3d90c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 16:03:31 -0400
Message-Id: <1181160211.6408.42.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.0, required=12.0, autolearn=disabled, AWL=-0.037)
X-UiO-Scanned: A2F0E551D6CE1C4E279EB6108EBB3F69A26EDB3A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 67 total 2220971 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 20:03 +0300, Raz Ben-Jehuda(caro) wrote:
> If my understanding ( from "see : understand the linux
> kernel" page 310 ) , a different kernel component holds this window. A
> fact which is quite strange in the case of KM_SKB_SUNRPC_DATA. I have
> nothing that uses it.

KM_SKB_SUNRPC_DATA is verboten unless you are running in the appropriate
bh-safe socket environment. Otherwise, see Jens' comment.

Trond

