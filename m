Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZA3QFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZA3QFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZA3QFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:05:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49005 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbZA3QFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:05:23 -0500
Date: Fri, 30 Jan 2009 11:04:31 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86/powernow: fix cpus_allowed brokage when acpi=off
Message-ID: <20090130160431.GA12130@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Langsdorf, Mark" <mark.langsdorf@amd.com>,
	Mike Travis <travis@sgi.com>
References: <498136FC.2020206@kernel.org> <200901301210.48352.rusty@rustcorp.com.au> <20090130151701.GD27549@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130151701.GD27549@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 04:17:01PM +0100, Ingo Molnar wrote:
 > >    Yinghai, as far as I can tell your other fixes are independent (and
 > > were a problem before this commit, yes?).  Can you re-submit them on top
 > > of this patch (which is for Ingo, but against latest Linus).
 > > 
 > > Subject: cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
 > > 
 > > Impact: fix powernow-k8 when acpi=off (or other error).
 > > 
 > > There was a spurious change introduced into powernow-k8 in this patch:
 > > the cause if that we try to "restore" the cpus_allowed we never saved.
 > > 
 > > See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
 > > acpi=off" from Yinghai for the bug report.
 > > 
 > > Cc: Mike Travis <travis@sgi.com>
 > > Cc: Yinghai Lu <yinghai@kernel.org>
 > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
 > 
 > applied to tip/x86/urgent, thanks guys!
 > 
 > Dave, is it fine if we send the fix to Linus via this route - or would you 
 > like to do it yourself?

I thought this was only in your tree, so I was letting you do the work anyway :-)

I'm fine with it, as long as it goes in soon.

	Dave

-- 
http://www.codemonkey.org.uk
