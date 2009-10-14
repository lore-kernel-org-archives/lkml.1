Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbZJNNRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbZJNNRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761540AbZJNNRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:17:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbZJNNRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:17:32 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] vfs: new O_NODE open flag
Date: Wed, 14 Oct 2009 15:14:52 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc6-git3-4-pae; KDE/4.1.3; i686; ; )
Cc: Andreas Dilger <adilger@sun.com>, Valdis.Kletnieks@vt.edu,
       linux@treblig.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <20090928152128.GA3384@webber.adilger.int> <E1MsIhu-0002AY-F2@pomaz-ex.szeredi.hu>
In-Reply-To: <E1MsIhu-0002AY-F2@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910141514.52811.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 September 2009 18:04:10 Miklos Szeredi wrote:
> The point of the above example was that reopening a file descriptor
> with upgraded (or downgraded) access mode is even now possible.  Which
> either means:
> 
>  a) the current permission model under /proc/PID/fd has a security
>     hole (which Jamie is worried about)

No worries -- access to /proc/PID/fd/* requires ptrace access to PID, so we do 
not have a security hole here. The ptrace checks were introduced here:

	778c1144771f0064b6f51bee865cceb0d996f2f9
	df26c40e567356caeefe2861311e19c54444d917

Cheers,
Andreas
