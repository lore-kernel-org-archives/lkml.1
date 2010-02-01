Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0BABXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 20:23:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0BABXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 20:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AZAX8zK4aKO//dwOMIG8JQzgFqxkaGw1Vzu//fhZTbnauuoAF8R+l/4c47sxlcrjJ6
         ENlzjXAcZiy2Ue18s2RBXw2op6IrZDaGkSXKk4zCmxY8iSB20dTP+Wvb1gArrFQvgQ+y
         vYZDVN6wb6VTX41EY6LsX31U7/h6mEHY46mjA=
Date: Mon, 1 Feb 2010 02:23:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lock dependency based tree report in perf lock
Message-ID: <20100201012331.GH5224@nowhere>
References: <20100129231723.GB5052@nowhere> <1264841188.24455.54.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264841188.24455.54.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 09:46:28AM +0100, Peter Zijlstra wrote:
> On Sat, 2010-01-30 at 00:17 +0100, Frederic Weisbecker wrote:
> > 
> > 
> > Anyway, that's just an idea, not trivial I must admit.
> 
> lockdep actually collects all this information, so writing it out isn't
> too hard.


Hmm, I'm discovering the /proc/lock_stat file this evening, did not
know it exist :)

Still, a tree representation can bring another dimension.

