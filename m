Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbXD0TVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbXD0TVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757144AbXD0TVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:21:20 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757132AbXD0TVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:21:19 -0400
Date: Fri, 27 Apr 2007 12:20:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "VE \(HOME\)" <ve@vetienne.net>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, <fubar@us.ibm.com>,
       <bonding-devel@lists.sourceforge.net>, netdev@vger.kernel.org
Subject: Re: [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1
Message-Id: <20070427122039.98e02471.akpm@linux-foundation.org>
In-Reply-To: <010a01c788ae$0a7d0140$5601a8c0@apws2>
References: <200704262058.33087.ve@vetienne.net>
	<20070426211146.f370cf81.akpm@linux-foundation.org>
	<010a01c788ae$0a7d0140$5601a8c0@apws2>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 11:25:46 +0200 "VE \(HOME\)" <ve@vetienne.net> wrote:

> Andrew Morton wrote:
> > On Thu, 26 Apr 2007 20:58:32 +0200 Vincent ETIENNE <ve@vetienne.net>
> > wrote:
> >
> >
> > This was due to locking bustage in the net tree.  It should be fixed
> > in 2.6.21-rc7-mm2.
> 
> I have tried this version. Same problem ( see 
> http://mail1.vetienne.net/linux/dmesg-2.6.21-rc7-mm2.log )

That file has disappeared.

> But also a new problem with USB keyboard/mouse
> 

USB problem - let's handle that separately.

> 
> And also a strange problem : dhcp server and dns server was started before 
> bond0 was completly up ( eth0 and eth1 was declared down at this time and 
> up a few times later : was not the case with later 2.6.21-rc6-mm1 )
> 


