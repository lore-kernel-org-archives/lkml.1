Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbXGLWsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbXGLWsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 18:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbXGLWsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 18:48:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:47002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbXGLWsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 18:48:10 -0400
From: Neil Brown <neilb@suse.de>
To: LinuxKernel@jamesplace.net
Date: Fri, 13 Jul 2007 08:48:15 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18070.44975.347933.29688@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem recovering a failed RIAD5 array with 4-drives.
In-Reply-To: message from James on Thursday July 12
References: <200707120849.16068.LinuxKernel@jamesplace.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 12, LinuxKernel@jamesplace.net wrote:
> 
> []# 
> mdadm --create --verbose /dev/md0 --assume-clean --level=raid5 --raid-devices=4 --spare-devices=0  /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> 
snip
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       33        1      active sync   /dev/sdc1
>        2       8        1        2      active sync   /dev/sda1
>        3       8       49        3      active sync   /dev/sdd1

Something looks very wrong here.  You listed the devices to --create
in one order:
   a b c d
but that appear in the array in a different order
   b c a d

Did you cut/paste the command line into the mail, or did you retype
it?  If you retyped it, could you have got it wrong?

You need the order that --detail shows to match the order of the
original array....

NeilBrown
