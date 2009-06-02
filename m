Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZFBAS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZFBAS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZFBASv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:18:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47318 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZFBASv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:18:51 -0400
Date: Tue, 2 Jun 2009 02:14:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH? tracehook_report_clone: fix false positives
Message-ID: <20090602001424.GA986@redhat.com>
References: <20090528113601.GA18725@redhat.com> <20090528114100.GA18744@redhat.com> <20090528212418.2F605FC2BD@magilla.sf.frob.com> <20090529122411.GC19812@redhat.com> <20090530185212.GA10677@redhat.com> <20090601002226.480CEFC3C7@magilla.sf.frob.com> <20090601200723.GA22204@redhat.com> <20090601205056.16307FC3C7@magilla.sf.frob.com> <20090601213443.GA26291@redhat.com> <20090601231939.223CEFC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601231939.223CEFC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Roland McGrath wrote:
>
> This is where the utrace attachment point has to be (i.e. outside all the
> locking).

Yes I see. Quoting myself:

	Yes, utrace-ptrace will likely change this code further anyway
	and move the code from _init() to _report_clone() back, but in this case
	I guess the whole tracehook_finish_clone() will go away, so this change
	looks right anyway to me.

> So I don't see any benefit to changing the ptrace status quo now
> for its own sake.

OK, agreed.

Oleg.

