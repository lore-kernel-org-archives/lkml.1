Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXDOKXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXDOKXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXDOKXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:23:25 -0400
Received: from mx1.suse.de ([195.135.220.2]:49054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXDOKXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:23:24 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: 2.6.21-rc6 + firstfloor patches: BUG: sleeping function called from invalid context at kernel/sched,.c:3643
Date: Sun, 15 Apr 2007 12:23:19 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <462072C2.4070605@goop.org> <200704141338.50058.ak@suse.de> <462143B9.6080907@goop.org>
In-Reply-To: <462143B9.6080907@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151223.19599.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 April 2007 23:12:25 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Fixed now. The latest sched-clock was leaking preempt counts during
> > cpu frequency changes.
> >   
> 
> No, that didn't help.  I think its cpufreq:

Hmm, are you sure? Can you double check?  With the latest tree?

I could reproduce the problem and my change fixed the problem for me.

-Andi
