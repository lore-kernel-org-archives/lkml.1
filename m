Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbZKESlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbZKESlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbZKESlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:41:45 -0500
Received: from relay3.sgi.com ([192.48.152.1]:46888 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758475AbZKESln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:41:43 -0500
Date: Thu, 5 Nov 2009 12:41:44 -0600
From: Jack Steiner <steiner@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Kosina <jkosina@suse.cz>,
       Michael Gilbert <michael.s.gilbert@gmail.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: CVE-2009-2584
Message-ID: <20091105184144.GA19372@sgi.com>
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com> <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain> <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain> <200911051847.36103.mb@bu3sch.de> <20091105181628.GA2239@sgi.com> <alpine.LFD.2.01.0911051021320.31845@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911051021320.31845@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 10:22:43AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 5 Nov 2009, Jack Steiner wrote:
> > 
> > "buf" should be larger than 16. The string could be "0x" + 16 characters.
> 
> I have 'char buf[20];' in my tree now.
> 
> > I'll verify the the rest.
> > 
> > We have the hardware :-)
> 
> Thanks. I've committed it locally, but if I get a tested-by or an ack (or 
> a fix) soon enough, I'll update the commit before I push it out.

Tested on real hardware.

Acked-by: Jack Steiner <steiner@sgi.com>


--- jack
