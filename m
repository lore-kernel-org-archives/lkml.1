Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbZJHB6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbZJHB6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbZJHB6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:58:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990AbZJHB6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:58:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
In-Reply-To: Oleg Nesterov's message of  Wednesday, 7 October 2009 13:30:49 +0200 <20091007113049.GA3421@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com>
	<20091003171029.GA30442@us.ibm.com>
	<20091004021844.GA21006@redhat.com>
	<20091004021918.GB21006@redhat.com>
	<20091006073100.4184128@magilla.sf.frob.com>
	<20091006133732.GB8628@redhat.com>
	<20091006175705.6547A22@magilla.sf.frob.com>
	<20091007113049.GA3421@redhat.com>
X-Zippy-Says: Maybe we could paint GOLDIE HAWN a rich PRUSSIAN BLUE--
Message-Id: <20091008015748.AC19D8D@magilla.sf.frob.com>
Date: Wed,  7 Oct 2009 18:57:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this doesn't matter because we need more cleanups. 

Ok, good enough for me.

> The problem is, both SI_FROMUSER() and SI_FROMKERNEL() must die imho.
> In fact I think they should never exist.

I've always found all the si_code hackery rather confusing.  (Don't forget
the crucial magic (short) cast repeated three places in exit.c without a
comment between them!)

> Other cleanups which imho makes sense:
> 
> 	- rename SEND_SIG_XXX
> 
> 	- redefine them to make sure SEND_SIG_NOINFO != NULL

Sounds good to me.


Thanks,
Roland
