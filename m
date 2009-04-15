Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZDOHf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZDOHf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZDOHfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:35:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43202 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZDOHfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:35:14 -0400
Date: Wed, 15 Apr 2009 16:33:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Malek <dan@embeddedalley.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Message-Id: <20090415163340.9950972a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <B0C7ECF0-ED36-4C45-95F6-37E61EB3F121@embeddedalley.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com>
	<20090415093555.d84b6655.kamezawa.hiroyu@jp.fujitsu.com>
	<70C851F4-3BEA-4DF0-943E-4740A2E5A844@embeddedalley.com>
	<20090415115811.0d609e52.kamezawa.hiroyu@jp.fujitsu.com>
	<B0C7ECF0-ED36-4C45-95F6-37E61EB3F121@embeddedalley.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 00:32:29 -0700
Dan Malek <dan@embeddedalley.com> wrote:

> 
> On Apr 14, 2009, at 7:58 PM, KAMEZAWA Hiroyuki wrote:
> 
> > Memory cgroup is a feature both for very-small-system and very- 
> > large-system.
> >
> > XXMB(KB) for limit is an idea.
> > # echo 100MB > memory.limit_in_bytes.
> > # echo 5MB > memory.notify_triger_thresh_in_bytes.
> >
> > Notify will be generated at 95MB of usage.
> 
> I get it, I'll change it.
> 
> > The VM monitor application will work like
> 
> I see.  Let me finish my patch first, then we
> can discuss this some more?
> 
yes. Let's go step-by-step.

Thanks,
-Kame

> Thanks.
> 
> 	-- Dan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

