Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYLOJW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYLOJW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 04:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYLOJWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 04:22:19 -0500
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:45812 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYLOJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 04:22:19 -0500
Date: Mon, 15 Dec 2008 09:21:43 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, arjan@infradead.org,
       dave@linux.vnet.ibm.com, containers@lists.osdl.org,
       ebiederm@xmission.com, sukadev@linux.vnet.ibm.com, serue@us.ibm.com,
       srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: graph of a single function
Message-ID: <20081215092143.GF7593@shadowen.org>
References: <20081203203656.776893226@goodmis.org> <20081203203828.920111079@goodmis.org> <20081203130859.fcf5a51e.akpm@linux-foundation.org> <alpine.DEB.1.10.0812031611000.29045@gandalf.stny.rr.com> <20081204084118.GG32594@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204084118.GG32594@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 09:41:18AM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Wed, 3 Dec 2008, Andrew Morton wrote:
> > 
> > > On Wed, 03 Dec 2008 15:36:57 -0500
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > +static struct seq_operations ftrace_graph_seq_ops = {
> > > > +	.start = g_start,
> > > > +	.next = g_next,
> > > > +	.stop = g_stop,
> > > > +	.show = g_show,
> > > > +};
> > > 
> > > This could be static I think.
> > 
> > s/static/const/
> > 
> > Damn damn damn damn!!!! I said to myself, I need to add const there and 
> > still forgot :-(
> 
> No need to get stressed up about such details - we need checkpatch help 
> for this.

This seems similar to the file_operations check we added recently.  As in
should we be suggesting that seq_operations should generally be const.
That seems consistant at least to my mind.

-apw
