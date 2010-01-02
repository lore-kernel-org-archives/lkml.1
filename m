Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269Ab0ABBkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0ABBkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 20:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196Ab0ABBkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 20:40:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:20539 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0ABBkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 20:40:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OJaGdcZ/uuY3RMOH3ewCdKXY61EM6og+A0N8v6gXZzwUf03E569fR3jia32X5CmJiI
         ZBiPbrSjDxDpDcUJ56IAfWm/BcATgPDYonT6eHJvft5s/ShpeViysjLSMJERG5Bei1J6
         2XbR+GwtScs+kLULBstdZY6fhw1ftDt7BRV3w=
Date: Sat, 2 Jan 2010 02:40:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] reiserfs lock inversion fixes on xattr
Message-ID: <20100102014003.GA5238@nowhere>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com> <1262205747-9208-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.01.0912301943020.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0912301943020.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 10:32:04PM -0800, Christian Kujau wrote:
> On Wed, 30 Dec 2009 at 21:42, Frederic Weisbecker wrote:
> > I hope you can give it a try (and/or review) before I send the whole
> > to Linus.
> 
> Without your patches, "dbench -x" was pretty much instantly causing the 
> threads to lock up, forcing me to reboot the box. With LOCKDEP enabled, 
> warnings were printed. After applying your patches (and a reboot) I've run 
> "dbench -x" for quite a while now with different runtimes and number of
> clients and it's not locking up any more. I've tested with:
> 
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_CHECK=y
> CONFIG_REISERFS_PROC_INFO=y
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> # CONFIG_REISERFS_FS_SECURITY is not set
> 
> ...and a few "Kernel hacking" options set. Full config and dmesg:
> 
>    http://nerdbynature.de/bits/2.6.33-rc1/reiserfs/t3/
> 
>    (although I'm not really testing -rc1 but latest mainline -git
>     and your changes pulled)
> 
> So, feel free to add:
> 
>   Tested-by: Christian Kujau <lists@nerdbynature.de>


Great, I've added this to the xattr related commits,
thanks a lot!


> 
> I can't help with the code review though :-\


Don't worry, both testing and review are very precious
and appreciated!

