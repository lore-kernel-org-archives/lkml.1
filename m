Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZB1TmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZB1TmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 14:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZB1Tly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 14:41:54 -0500
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:52026 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750977AbZB1Tlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 14:41:53 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sat, 28 Feb 2009 19:40:04 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] tracing: remove unused code
Message-ID: <20090228194004.GA9780@hades.domain.com>
References: <20090227202923.GA3826@hades.domain.com> <alpine.DEB.2.00.0902271535440.13395@gandalf.stny.rr.com> <20090228072137.GD9351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228072137.GD9351@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 08:21:37AM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Thanks Luis,
> > 
> > But before I remove this code, I want to move it to be 
> > activated by tracing options. The irqsoff tracer (and other 
> > latency tracers) are pretty useless without it.
> 
> sounds good.

Ok, understood.  I am sorry for the noise introduced by this patch... I should
have got some more context before submitting it -- I am really not that familiar
with this code and tried just to remove a compile warning without fully
understand the whole picture :-)

-- 
Luis Henriques
