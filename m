Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbXJOQ2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbXJOQ2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbXJOQ2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:28:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50216 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808AbXJOQ2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:28:37 -0400
Subject: Re: 2.6.23-mm1
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071013110103.ae4dd2da.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <4710FC91.6030806@googlemail.com>
	 <20071013110103.ae4dd2da.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 09:28:02 -0700
Message-Id: <1192465682.6118.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-13 at 11:01 -0700, Andrew Morton wrote:
> > I only have a WARNING in my dmesg but i don't think this is related to this :
> > 
> > Oct 13 01:44:52 lara [10722.146448] WARNING: at fs/namespace.c:586 __mntput()
> > Oct 13 01:44:52 lara [10722.146478]  [<c0167cb2>] mntput_no_expire+0x5d/0xab
> > Oct 13 01:44:52 lara [10722.146503]  [<c01683d1>] sys_umount+0x1f8/0x202
> > Oct 13 01:44:52 lara [10722.146511]  [<c010f368>] check_pgt_cache+0x13/0x15
> > Oct 13 01:44:52 lara [10722.146529]  [<c0158cd0>] sys_stat64+0xf/0x23
> > Oct 13 01:44:52 lara [10722.146549]  [<c0147a9c>] remove_vma+0x31/0x36
> > Oct 13 01:44:52 lara [10722.146574]  [<c010fbf6>] do_page_fault+0x180/0x4ea
> > Oct 13 01:44:52 lara [10722.146600]  [<c01683e6>] sys_oldumount+0xb/0xe
> > Oct 13 01:44:52 lara [10722.146614]  [<c010258e>] sysenter_past_esp+0x5f/0x85
> > Oct 13 01:44:52 lara [10722.146639]  [<c02e0000>] xfrm_tmpl_resolve+0x2bd/0x37b
> > Oct 13 01:44:52 lara [10722.146656]  =======================
> 
> I guess that's the r-o-bind-mounts stuff. 

Do you know any more about when this happened?  Was it during a reboot,
or after you unmounted some device or volume?  Have you seen it again?
Which filesystem(s) do you use?

-- Dave

