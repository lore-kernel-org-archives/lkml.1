Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYFPT4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYFPT4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYFPTz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:55:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbYFPTz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:55:56 -0400
Date: Mon, 16 Jun 2008 16:55:38 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Marco Barbero <marco.barbero@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: OOM killer invoked on 2.6.24.4
Message-ID: <20080616195538.GA9217@dmt.cnet>
References: <e1aa27e00806140313o5a62c618kb41b892b7b29e235@mail.gmail.com> <e2e108260806140831s40f36a95s1a412cec4dc47f31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260806140831s40f36a95s1a412cec4dc47f31@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 05:31:18PM +0200, Bart Van Assche wrote:
> On Sat, Jun 14, 2008 at 12:13 PM, Marco Barbero <marco.barbero@gmail.com> wrote:
> > samba/slapd/heartbeat/drbd/mon
> ...
> > Jun 14 01:00:17 pippo kernel: Out of memory: kill process 6873 (slapd)
> > score 5003 or a child
> > Jun 14 01:00:17 pippo kernel: Killed process 6873 (slapd)
> >
> > Anyone can help me in understanding what went wrong? And if I need to
> > upgrade to last kernel version?
> 
> One or more processes on your system used too much memory. Dumping the
> output of the following command periodically (e.g. every 10 minutes)
> to a file will tell you which process is using too much memory:
> 
> { ps aux | head -n 1; ps aux | sort -n +4 | tail -n 10; }

There were lots of swap free:

Jun 14 01:00:17 pippo kernel: Free swap  = 3903752kB
Jun 14 01:00:17 pippo kernel: Total swap = 3903752kB
Jun 14 01:00:17 pippo kernel: Free swap:       3903752kB

Something is wrong.

