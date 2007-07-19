Return-Path: <linux-kernel-owner+w=401wt.eu-S935169AbXGSMP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169AbXGSMP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934255AbXGSMPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:15:46 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54474 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935AbXGSMPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:15:44 -0400
Message-ID: <469F55F5.7040503@bull.net>
Date: Thu, 19 Jul 2007 14:15:49 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "tony.luck@intel.com" <tony.luck@intel.com>,
       nickpiggin@yahoo.com.au, mike@stroyan.net, dmosberger@gmail.com,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com> <20070719155632.7dbfb110.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070719155632.7dbfb110.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/07/2007 14:20:15,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/07/2007 14:20:18,
	Serialize complete at 19/07/2007 14:20:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Back to do_no_page():
> if the new PTE includes the exec bit and PG_arch_1 is set,
> the page has to be flushed from the I-cache before the PTE is
> made globally visible.

Sorry, I wanted to say:

if the new PTE includes the exec bit and PG_arch_1 is NOT set

Thanks,

Zoltan

