Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbXKMTm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbXKMTm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761310AbXKMTlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:41:18 -0500
Received: from mail.fieldses.org ([66.93.2.214]:55265 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519AbXKMTlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:41:14 -0500
Date: Tue, 13 Nov 2007 14:41:13 -0500
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stuck nfsd processes with 2.6.24-rc2
Message-ID: <20071113194113.GA22590@fieldses.org>
References: <alpine.DEB.0.9999.0711131955530.27452@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.9999.0711131955530.27452@sheep.housecafe.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 08:07:55PM +0100, Christian Kujau wrote:
> I noticed that I cannot use kernel nfsd any more with 2.6.24-rc2, last 
> working kernel as of now is 2.6.23.1. First I was using nfsv4 but switching 
> to nfsv3 did not help either: exported shares can be mounted (client: 
> 2.6-git/powerpc32, nfs-common-1.1.1~git-20070709-3ubuntu1), but running "ls 
> /mountpoint" (even without "-l") on the client is enough to get the [nfsd] 
> processes in "D" state.
> Restarting the rpc.nfsd process on the does not help much, the new rpc.nfsd 
> processes get stuck quickly.
>
> For more details please see http://nerdbynature.de/bits/2.6.24-rc2/nfsd/
>
> I haven't seen this particular issue on the list recently, hence my post.
> I'll try to git-bisect my way through the changesets, but it'll take some 
> time...

Could you get a sysrq-T trace?  (First get the [nfsd] processes in [D]
state.  Then type sysrq-T, or "echo t >/proc/sysrq-trigger".  Then
extract the stuff that's dumped to the logs.)

--b.
