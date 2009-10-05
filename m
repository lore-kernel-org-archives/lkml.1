Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZJEUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZJEUAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZJEUAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:00:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbZJEUAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:00:38 -0400
Date: Mon, 5 Oct 2009 21:55:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] signals: send_signal: use si_fromuser() to detect
	from_ancestor_ns
Message-ID: <20091005195544.GA5377@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com> <20091004021954.GC21006@redhat.com> <20091005181255.GE30442@us.ibm.com> <20091005182536.GA943@redhat.com> <20091005193738.GF30442@us.ibm.com> <20091005194415.GA4560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005194415.GA4560@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05, Oleg Nesterov wrote:
>
> On 10/05, Sukadev Bhattiprolu wrote:
> >
> > Oleg Nesterov [oleg@redhat.com] wrote:
>
> > | So, imho this patch also fixes this case by accident,
> >
> > This part I am not sure.  But as mentioned above, from_ancestor_ns is 0
> > and the SIGKILL will not queued right ?
>
> Yes, you are right, see above.
>
> I meant, it fixes the from-user logic, not from_ancestor_ns logic.

Hmm. When I re-read that email, I do not understand any longer
what I reallly meant when I said "this patch also fixes this case" :)

Anyway, you are right, thanks for correcting me.OH

Oleg.

