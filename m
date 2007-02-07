Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbXBGCKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbXBGCKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 21:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbXBGCKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 21:10:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:34671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbXBGCKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 21:10:02 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Feb 2007 13:09:28 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17865.13528.750067.168258@notabene.brown>
Cc: stable@kernel.org, nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] knfsd: Fix a race in closing NFSd connections.
In-Reply-To: message from Andrew Morton on Tuesday February 6
References: <20070207110636.9166.patches@notabene>
	<1070207001026.9413@suse.de>
	<20070206175152.39d767dd.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 6, akpm@linux-foundation.org wrote:
> 
> This patch assumes the presence of
> knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch which
> obviously isn't appropriate for -stable.

Only because they change adjacent lines.  There is no semantic
dependency.
The patch I sent will apply *correctly* against -stable with
"--fuzz=3".
I cannot send a fuzz-free patch if that would make Mr Stable happy.

> 
> Please confirm that the patch which I merged is still OK, thanks.

Yes, the patch which you merged is OK.

Thanks,
NeilBrown
