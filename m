Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZCDBqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZCDBqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZCDBpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:45:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52924 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887AbZCDBpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:45:50 -0500
Date: Wed, 4 Mar 2009 10:44:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: protagora27 protagora27 <protagora27@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: memory allocation over 4gb under x86_64
Message-Id: <20090304104424.dbc5692f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <5b9cce670903030322m9a5553fx2aa19f1591833f44@mail.gmail.com>
References: <5b9cce670903030322m9a5553fx2aa19f1591833f44@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009 12:22:18 +0100
protagora27 protagora27 <protagora27@gmail.com> wrote:

> Hello folks,
> 
> I have a 64 bit dma that I have to program with 64 bit physical
> address
> beyond 4 gb because I have to test dma with memory allocation beyond
> 4 gb.
> I 'm using linux x86_64 2.6.24 and I have 8 gb ram.
> How can I allocate physical dma memory beyond 4gb ? In x86_64
> can I use __pa to have physical address ?
> I have used kmalloc giving virtual address : ffff810225d10340
> and using __pa i have: 225d10340 that is over 8 gb .
> Does it mean that kmalloc return address is not linear mapped with phys ram ?
> 
IIUC, you can think that kmalloc() always retrun memory where __pa() works well.
Please check memory map of the host. It seems to have memory hole.

Thanks,
-Kame

> I would like to find a function that returns a physical adddres beyond
> 4gb
> and then i write phys address in dma register .
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

