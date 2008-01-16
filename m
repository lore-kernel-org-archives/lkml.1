Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYAQCNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYAQCNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYAQCNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:13:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:48672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYAQCNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:13:22 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Date: Wed, 16 Jan 2008 22:35:10 +0100
User-Agent: KMail/1.9.6
Cc: Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <patchbomb.1200435425@localhost> <200801162159.50274.ak@suse.de> <20080116210646.GA11967@elte.hu>
In-Reply-To: <20080116210646.GA11967@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801162235.11076.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 22:06:46 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > > truly stuck, or just an annoying message?
> > 
> > Just annoying message; system works after that for simple login etc. 
> > (haven't run anything complicated)
> 
> ok, if you see no other failures and if you have some time it would be 
> nice to figure out why that message is happening. Is NOHZ enabled 
> perhaps?

I updated now to latest git-x86 and the problem seems to have gone away.

But NO_HZ was enabled yes and the system also had a very unsynchronous
TSC (dual K8 opteron with cpufreq) 

Also I should say my patches were applied, but I didn't change
anything in this area.

-Andi

