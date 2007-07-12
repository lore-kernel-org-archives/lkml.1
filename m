Return-Path: <linux-kernel-owner+w=401wt.eu-S1763709AbXGLXV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763709AbXGLXV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbXGLXVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:21:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:35024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452AbXGLXVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:21:51 -0400
From: Neil Brown <neilb@suse.de>
To: LinuxKernel@jamesplace.net
Date: Fri, 13 Jul 2007 09:21:57 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18070.46997.541325.761868@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem recovering a failed RIAD5 array with 4-drives.
In-Reply-To: message from James on Thursday July 12
References: <200707120849.16068.LinuxKernel@jamesplace.net>
	<18070.44975.347933.29688@notabene.brown>
	<200707121810.57648.LinuxKernel@jamesplace.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 12, LinuxKernel@jamesplace.net wrote:
> 
> I don't know the original order of the array before all the problems started. 
> 
> Is there a way to determine the original order? 

No, unless you have some old kernel logs of the last time it assembled
the array properly.
The one thing that "--create" does destroy is the information about
any previous array that the drives were a part of.

> 
> The order that --detail is showing now is the order that appeared after 
> issuing the command is it is in the email. (ie: a b c d)

Odd.  I cannot reproduce it.
I suggest you try different arrangements (of the 3 good drives and the
word 'missing') until you find one that 'fsck -n' likes.

NeilBrown
