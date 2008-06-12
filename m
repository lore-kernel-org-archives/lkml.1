Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYFLK60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYFLK60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbYFLK6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:58:09 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47712 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612AbYFLK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:58:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
Date: Thu, 12 Jun 2008 12:58:33 +0200
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Nick Dokos <nicholas.dokos@hp.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Performance of ext4 
In-Reply-To: <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
	<20080611105945.GB9008@skywalker>
	<Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
	<18563.1213215457@alphaville.zko.hp.com>
	<Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
X-Mailer: VM 8.0.9 under Emacs 23.0.50.1 (i486-pc-linux-gnu)
From: Solofo.Ramangalahy@bull.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Holger,

Holger Kiehl writes:
 > That works until it comes to patch patches/ext4_ialloc-flexbg.patch when
 > it gets lots of rejects. So how do I set this up correctly?

I think your quilt is set up correctly.

The rejects probably come from the patch queue being based on a
different version than 2.6.26-rc5.

Which patchset did you use?

What I do when wanting a patch queue for a specific kernel is to
search for commit message indicating the rebase for this version.

There is a "Rebase to linux-2.6.26-rc5" on
http://repo.or.cz/w/ext4-patch-queue.git
So the corresponding snapshot
http://repo.or.cz/w/ext4-patch-queue.git?a=snapshot;h=ed6aaac3b0cc0ba47dbb2af0884306584271e5a2;sf=tgz
patches 2.6.26-rc5 smoothly.
(the last patchset also applies, with offset and fuzz, though)

-- 
solofo
