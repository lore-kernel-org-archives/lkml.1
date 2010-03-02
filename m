Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab0CBRy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:54:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0CBRy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:54:58 -0500
Subject: Re: [tip:perf/core] perf_events, x86: Fixup fixed counter
 constraints
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <bd4cb8901003020826w6540ffebje2cee53b52f1ff27@mail.gmail.com>
References: <tip-b622d644c7d61a5cb95b74e7b143c263bed21f0a@git.kernel.org>
	 <bd4cb8901003020826w6540ffebje2cee53b52f1ff27@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 18:54:52 +0100
Message-ID: <1267552492.25158.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 17:26 +0100, Stephane Eranian wrote:
> > @@ -37,14 +43,16 @@ static struct event_constraint intel_core2_event_constraints[] =
> >        INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
> >        INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
> >        INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
> > +       INTEL_EVENT_CONSTRAINT(0xc9, 0x1), /* ITLB_MISS_RETIRED (T30-9) */
> 
> Where does the constraint on ITLB_MISS_RETIRED come from?

Intel® 64 and IA-32 Architectures Software Developer’s Manual
Volume 3B: System Programming Guide, Part 2

Dec 2009 (253669)

Section 30.4.3, Table 30-9

