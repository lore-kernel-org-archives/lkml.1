Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbXKTGRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbXKTGRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbXKTGQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:16:55 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:53046 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXKTGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:16:54 -0500
Date: Tue, 20 Nov 2007 01:16:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Bastian Blank <bastian@waldi.eu.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com
Subject: Re: [PATCH 7/24] consolidate msr.h
In-Reply-To: <20071120055113.GC20436@elte.hu>
Message-ID: <Pine.LNX.4.58.0711200114580.4062@gandalf.stny.rr.com>
References: <11946337851964-git-send-email-gcosta@redhat.com>
 <11946337933104-git-send-email-gcosta@redhat.com>
 <11946337991750-git-send-email-gcosta@redhat.com>
 <11946338053158-git-send-email-gcosta@redhat.com>
 <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com>
 <11946338212915-git-send-email-gcosta@redhat.com>
 <11946338263902-git-send-email-gcosta@redhat.com> <20071119222151.GA11178@wavehammer.waldi.eu.org>
 <Pine.LNX.4.58.0711191734270.32296@gandalf.stny.rr.com> <20071120055113.GC20436@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 Nov 2007, Ingo Molnar wrote:
>
> i dont think there's ever any true need (and good cause) to force
> integer type casts like that at the callee site.

Unless you mean we should do something like this:

static inline void __wrmsrl(unsigned int msr, unsigned long long val);
#define wrmsr(msr, val) __wrmsrl(msr, (unsigned long long)var)

-- Steve


