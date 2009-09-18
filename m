Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbZIRIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbZIRIAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 04:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZIRIA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 04:00:29 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:56639 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057AbZIRIA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 04:00:29 -0400
X-Trace: 259507654/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.69.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.69.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAFfbskpQKUVD/2dsb2JhbACBUtJuhBwF
X-IronPort-AV: E=Sophos;i="4.44,408,1249254000"; 
   d="scan'208";a="259507654"
Date: Fri, 18 Sep 2009 08:59:40 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
In-Reply-To: <1253260528.4959.13.camel@penberg-laptop>
Message-ID: <Pine.LNX.4.64.0909180857170.5404@sister.anvils>
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org> 
 <1253227412-24342-3-git-send-email-ngupta@vflare.org> 
 <1253256805.4959.8.camel@penberg-laptop>  <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
 <1253260528.4959.13.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Pekka Enberg wrote:
> 
> The *hook* looks OK to me but set_swap_free_notify() looks like an ugly
> hack. I don't understand why we're setting up the hook lazily in
> ramzswap_read() nor do I understand why we need to look up struct
> swap_info_struct with a bdev. Surely there's a cleaner way to do all
> this? Probably somewhere in sys_swapon()?

Sounds like you have something in mind, may well be better,
but please show us a patch...  (my mind is elsewhere!)

Hugh
