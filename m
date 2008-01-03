Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYACNKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYACNKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYACNJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:09:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:56370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYACNJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:09:53 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: git-x86 broken on 32bit
Date: Thu, 3 Jan 2008 14:09:49 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com
References: <200801030111.40061.ak@suse.de> <20080103075758.GA2351@elte.hu> <20080103081025.GA3239@elte.hu>
In-Reply-To: <20080103081025.GA3239@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031409.49467.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 09:10:25 Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Andi Kleen <ak@suse.de> wrote:
> > 
> > > Current git-x86 seems to be totally broken on i386
> > > 
> > > commit a6f08929f0566f9d309ef5f6651371d8e20fc833
> > > Author: Russell Leidich <rml@google.com>
> > > Date:   Wed Jan 2 22:46:22 2008 +0100
> > 
> > that patch was not included in x86.git anymore at the time you wrote 
> > your email. You probably picked up an interim version of the queue 
> > that had the breakage - i noticed it and pulled it a few minutes 
> > later.
> 
> correction: i had fixed it but did not push it out - pushed it out now. 
> Please check that it works for you.

I'll check once git.kernel.org unbreaks itself

% git pull -u
fatal: The remote end hung up unexpectedly
Cannot get the repository state from git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

-Andi

