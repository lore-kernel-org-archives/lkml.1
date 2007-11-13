Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbXKMT5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbXKMT5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbXKMT44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:56:56 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:35231 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759097AbXKMT4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:56:55 -0500
X-Greylist: delayed 2931 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 14:56:54 EST
Date: Tue, 13 Nov 2007 20:07:55 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: linux-kernel@vger.kernel.org
cc: bfields@fieldses.org
Subject: stuck nfsd processes with 2.6.24-rc2
Message-ID: <alpine.DEB.0.9999.0711131955530.27452@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I noticed that I cannot use kernel nfsd any more with 2.6.24-rc2, last 
working kernel as of now is 2.6.23.1. First I was using nfsv4 but 
switching to nfsv3 did not help either: exported shares can be mounted 
(client: 2.6-git/powerpc32, nfs-common-1.1.1~git-20070709-3ubuntu1), but 
running "ls /mountpoint" (even without "-l") on the client is enough to 
get the [nfsd] processes in "D" state.
Restarting the rpc.nfsd process on the does not help much, the new 
rpc.nfsd processes get stuck quickly.

For more details please see http://nerdbynature.de/bits/2.6.24-rc2/nfsd/

I haven't seen this particular issue on the list recently, hence my post.
I'll try to git-bisect my way through the changesets, but it'll take some 
time...

Thanks,
Christian.
-- 
BOFH excuse #314:

You need to upgrade your VESA local bus to a MasterCard local bus.
