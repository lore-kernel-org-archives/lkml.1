Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYBVRJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYBVRJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYBVRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:09:19 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59262 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYBVRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:09:17 -0500
Date: Fri, 22 Feb 2008 09:09:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Patrick McHardy <kaber@trash.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
Message-ID: <20080222170908.GA9386@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47BC982C.7050402@imap.cc> <47BD6072.4000407@trash.net> <47BE1A03.30300@imap.cc> <47BE1CE5.1030001@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE1CE5.1030001@imap.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 01:52:53AM +0100, Tilman Schmidt wrote:
> Am 22.02.2008 01:40 schrieb Tilman Schmidt:
> >>
> >>     [NETFILTER]: nf_conntrack: fix smp_processor_id() in preemptible code warning
> > 
> > Yes, it does; and the system also survives substantially longer.
> > (IOW, it hasn't crashed on me so far.)
> 
> Which of course it did the second after I sent off that mail. :-(
> No message at all this time at the time of the crash, even though
> I had "tail -f /var/log/messages" running in an ssh session.
> 
> So the nf_conntrack BUG is fixed, but the crash (and of course the
> swapper "spinlock bad magic" BUG) persists.

Do you have CONFIG_DEBUG_PREEMPT set?  That would help find any other
bugs similar to nf_conntrack.

							Thanx, Paul
