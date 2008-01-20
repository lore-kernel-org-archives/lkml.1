Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYATJwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYATJwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYATJwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:52:07 -0500
Received: from 1wt.eu ([62.212.114.60]:1428 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbYATJwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:52:06 -0500
Date: Sun, 20 Jan 2008 10:25:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc8-git does not boot on Geode LX
Message-ID: <20080120092558.GA6515@1wt.eu>
References: <20080120081442.GA12713@1wt.eu> <20080120091315.GA8379@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120091315.GA8379@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, Jan 20, 2008 at 10:13:15AM +0100, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > Checking 'hlt' instruction... OK.                                               
> > Freeing SMP alternatives: 0k freed                                              
> > net_namespace: 64 bytes                                                         
> > NET: Registered protocol family 16                                              
> > -----> hangs here <-----
> 
> just a hint: this is near the first piece of code that makes active use 
> of a timer wakeup, on a typical x86 bootup. So sometimes if timers are 
> not working at all, hangs happen around here. But the PCI related thing 
> you suspect could be the reason too. Getting a SysRq-T or an NMI 
> printout (if that's possible) of the hung site would be nice.

OK Thanks for the hint, I'll try things like this when I get back home.

Cheers,
Willy

