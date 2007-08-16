Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbXHPWTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbXHPWTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbXHPWTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:19:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56860 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759662AbXHPWTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:19:17 -0400
From: Gabor Kovacs <kgabor@bolyai.elte.hu>
Subject: User process freezes on NFSv4 client
Date: Thu, 16 Aug 2007 18:19:14 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708161819.14437.kgabor@bolyai.elte.hu>
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I've got NFSv4 problems on a big partition. Both NFS server and client run 
kernel version 2.6.21.6. Exported file system is on an AoE etherdrive 
(/dev/etherd/e1.1) device, having no partition table, XFS file system. The 
file system is pretty large,  8.9T. Typical file size 1-10M. 

On the client side, after much time (3-7 days) of file intensive task, the 
user process freezes. Top command shows a "D" state for it, but many other 
command trying to "touch" it, freezes, too. (ps, fuser /nfs_dir, w) None of 
the frozen processes can be killed. New processes, however, can access the 
nfs4 mounted file system. Any idea?

Thanks
Gabor Kovacs
