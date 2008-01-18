Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbYARVs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbYARVs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYARVsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:48:19 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60348 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005AbYARVsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:48:18 -0500
Subject: Re: [PATCH 0/10] Tree fixes for PARAVIRT
From: Zachary Amsden <zach@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       roland@redhat.com, mtosatti@redhat.com
In-Reply-To: <20080118213711.GA24979@elte.hu>
References: <12006768251548-git-send-email-gcosta@redhat.com>
	 <20080118203259.GA3079@elte.hu>  <20080118213711.GA24979@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 13:54:08 -0800
Message-Id: <1200693248.21817.157.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 22:37 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > The first fix is not even specific for PARAVIRT, and it's actually 
> > > preventing the whole tree from booting.
> > 
> > on CONFIG_EFI, indeed :)
> 
> but in exchange you broke all of 32-bit with CONFIG_PARAVIRT=y. Which 
> means you did not even build-test it on 32-bit, let alone boot test 
> it...

Why are we rushing so much to do 64-bit paravirt that we are breaking
working configurations?  If the developement is going to be this
chaotic, it should be done and tested out of tree until it can
stabilize.

I do not like having to continuously retest and review the x86 branch
because the paravirt-ops are constantly in flux and the 32-bit code
keeps breaking.

We won't be doing 64-bit paravirt-ops for exactly this reason - is there
a serious justification from the performance angle on modern 64-bit
hardware?  If not, why justify the complexity and hackery to Linux?

Zach

