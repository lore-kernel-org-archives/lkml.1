Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553Ab0A0LVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0A0LVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508Ab0A0LVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:21:09 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60821 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab0A0LVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:21:08 -0500
Date: Wed, 27 Jan 2010 16:50:55 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Tom Tromey <tromey@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, avi@redhat.com
Subject: Re: linux-next: add utrace tree
Message-ID: <20100127112055.GA14289@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain> <1264589716.4283.2006.camel@laptop> <20100127110555.GB1842@in.ibm.com> <1264590511.4283.2009.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264590511.4283.2009.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 12:08:31PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-27 at 16:35 +0530, Ananth N Mavinakayanahalli wrote:
> > Probing RIP-relative instructions work just fine; there are fixups that
> > take care of it. 
> 
> Ah my bad then, it was my understanding you simply bailed on those.
> 
> Just for my information, how large are the replacement sequences?

The RIP relative instruction is transformed into indirect addressing
mode using a scratch register.

For details http://marc.info/?l=linux-kernel&m=126401936114639&w=2. 

Ananth
