Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYLDImg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYLDImg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbYLDImW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:42:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33541 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbYLDImV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:42:21 -0500
Date: Thu, 4 Dec 2008 09:41:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>, Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, arjan@infradead.org,
       dave@linux.vnet.ibm.com, containers@lists.osdl.org,
       ebiederm@xmission.com, sukadev@linux.vnet.ibm.com, serue@us.ibm.com,
       srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: graph of a single function
Message-ID: <20081204084118.GG32594@elte.hu>
References: <20081203203656.776893226@goodmis.org> <20081203203828.920111079@goodmis.org> <20081203130859.fcf5a51e.akpm@linux-foundation.org> <alpine.DEB.1.10.0812031611000.29045@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812031611000.29045@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 3 Dec 2008, Andrew Morton wrote:
> 
> > On Wed, 03 Dec 2008 15:36:57 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > +static struct seq_operations ftrace_graph_seq_ops = {
> > > +	.start = g_start,
> > > +	.next = g_next,
> > > +	.stop = g_stop,
> > > +	.show = g_show,
> > > +};
> > 
> > This could be static I think.
> 
> s/static/const/
> 
> Damn damn damn damn!!!! I said to myself, I need to add const there and 
> still forgot :-(

No need to get stressed up about such details - we need checkpatch help 
for this.

	Ingo
