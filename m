Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYJUGQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYJUGQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYJUGQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:16:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51940 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbYJUGQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:16:13 -0400
Date: Tue, 21 Oct 2008 15:15:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] Fix page_cgroup build breakage
Message-Id: <20081021151546.fdbf5f9d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081021061219.GA4980@osiris.boeblingen.de.ibm.com>
References: <20081021061219.GA4980@osiris.boeblingen.de.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 08:12:19 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Subject: [PATCH] Fix page_cgroup build breakage
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> On s390 I get this:
> 
>   CC      mm/page_cgroup.o
> mm/page_cgroup.c: In function 'init_section_page_cgroup':
> mm/page_cgroup.c:111: error: implicit declaration of function 'vmalloc_node'
> mm/page_cgroup.c:111: warning: assignment makes pointer from integer without a cast
> mm/page_cgroup.c: In function '__free_page_cgroup':
> mm/page_cgroup.c:140: error: implicit declaration of function 'vfree'
> make[1]: *** [mm/page_cgroup.o] Error 1
> make: *** [mm] Error 2
> 
> caused by 52d4b9ac0b985168009c2a57098324e67bae171f
> ("memcg: allocate all page_cgroup at boot")
> 
Thank you and sorry.

Note: same as mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch
      in mm-stack.


Regards,
-Kame

