Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbXIZF3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbXIZF3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 01:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXIZF3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 01:29:39 -0400
Received: from 1wt.eu ([62.212.114.60]:2701 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXIZF3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 01:29:38 -0400
Date: Wed, 26 Sep 2007 07:25:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Adrian Bunk <bunk@kernel.org>, David Newall <david@davidnewall.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070926052553.GK10199@1wt.eu>
References: <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 01:21:08AM -0400, Kyle Moffett wrote:
(...)
> Now, like magic, the entire system is once more accessible.
> 
> Alternatively you could:
>   mount -t proc proc /proc
>   cat /proc/1/mounts
>   mount -t $ROOTFS_FROM_PROC $ROOTDEV_FROM_PROC /

Since 2.6.20, it was even simpler :
   mount -t proc proc /proc
   cd /proc/1/cwd

Cheers,
Willy

