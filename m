Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbZGPNTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbZGPNTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZGPNTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:19:14 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:44890 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756230AbZGPNTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:19:13 -0400
X-Sender-Authentication: net64
Date: Thu, 16 Jul 2009 15:19:08 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: David Rientjes <rientjes@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: What to do with this message (2.6.30.1) ?
Message-Id: <20090716151908.f032cfa2.skraw@ithnet.com>
In-Reply-To: <alpine.DEB.2.00.0907151321030.22582@chino.kir.corp.google.com>
References: <20090713134621.124aa18e.skraw@ithnet.com>
	<4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com>
	<alpine.DEB.2.00.0907132247001.8784@chino.kir.corp.google.com>
	<20090715084754.36ff73bf.skraw@ithnet.com>
	<alpine.DEB.2.00.0907150115190.14393@chino.kir.corp.google.com>
	<20090715114605.42a354c0.skraw@ithnet.com>
	<alpine.DEB.2.00.0907151321030.22582@chino.kir.corp.google.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 13:22:51 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 15 Jul 2009, Stephan von Krawczynski wrote:
> 
> > Ok, so I just found out that slabtop -o outputs a lot of ANSI code by
> > redirecting it, that output is merely unreadable. Can some kind soul please
> > tell the author that formatting ANSI output in -o option makes no sense at
> > all. top btw does not do this (top -b -n 1).
> > I will produce your logs, but you will have a hard time reading that trash ...
> > 
> 
> This is fixed in the latest release of procps[*], so maybe you could 
> upgrade before generating the output?  If not, simply sending 
> /proc/slabinfo would be better.
> 
>  [*] https://rhn.redhat.com/errata/RHBA-2009-0950.html
> 

Perhaps they also fixed this output, starting slabtop from cron:

tcgetattr: Inappropriate ioctl for device
Error opening terminal: unknown.

We had no logs tonight because of this, nevertheless the problem itself is
still there, so we better produce cat /proc/slabinfo as a start ...

-- 
Regards,
Stephan

