Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYCKK2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYCKK2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYCKK2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:28:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41386 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYCKK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:28:42 -0400
Date: Tue, 11 Mar 2008 19:23:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/3] memcg: put a restriction on writing
 memory.force_empty
Message-Id: <20080311192338.9f89ca70.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47D65BAA.60908@linux.vnet.ibm.com>
References: <47D65A36.4020008@cn.fujitsu.com>
	<47D65BAA.60908@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 15:45:06 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Li Zefan wrote:
> > We can write whatever to memory.force_empty:
> > 
> >         echo 999 > memory.force_empty
> >         echo wow > memory.force_empty
> > 
> > This is odd, so let's make '1' to be the only valid value.
> 
> I suspect as long as there is no unreasonable side-effect, writing 999 or wow
> should be OK.
> 
I agree with Balbir.

Thanks,
-Kame

