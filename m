Return-Path: <linux-kernel-owner+w=401wt.eu-S932667AbZJ1IK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbZJ1IK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932640AbZJ1IK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:10:28 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:40244 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932638AbZJ1IK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:10:27 -0400
X-Trace: 276746418/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.58.43/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.58.43
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsBAK+Z50pPRTor/2dsb2JhbAAI2VKEPwQ
X-IronPort-AV: E=Sophos;i="4.44,638,1249254000"; 
   d="scan'208";a="276746418"
Date: Wed, 28 Oct 2009 08:10:35 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: David Rientjes <rientjes@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <alpine.DEB.2.00.0910272111400.8988@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0910280801240.20397@sister.anvils>
References: <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <20091028113713.FD85.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.0910272111400.8988@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, David Rientjes wrote:
> 
> Not sure where the -stable reference came from, I don't think this is a 
> candidate.

I agree with David, this is only one little piece of a messy puzzle,
there's no good reason to rush this into -stable.

> > +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> > +	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
> > +	    has_capability_noaudit(p, CAP_SYS_RAWIO))
> 
> Acked-by: David Rientjes <rientjes@google.com>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

(as far as it goes: the whole thing of quartering badness here
because "we don't want to kill" and "important" is questionable;
but definitely much more open to argument both ways than sixteenthing).
