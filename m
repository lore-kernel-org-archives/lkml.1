Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZAaPHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZAaPHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 10:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZAaPHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 10:07:11 -0500
Received: from agrajag.mansr.com ([78.86.181.102]:59883 "EHLO mail.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZAaPHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 10:07:09 -0500
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH D 01/11] OMAP: Add clk_get_parent() for OMAP2/3
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
	<20090128191807.16688.91255.stgit@localhost.localdomain>
	<20090129110043.GE12627@n2100.arm.linux.org.uk>
	<alpine.DEB.2.00.0901292327090.26985@utopia.booyaka.com>
	<20090131142344.GM1394@n2100.arm.linux.org.uk>
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Sat, 31 Jan 2009 15:07:06 +0000
In-Reply-To: <20090131142344.GM1394@n2100.arm.linux.org.uk> (Russell King's message of "Sat, 31 Jan 2009 14:23:44 +0000")
Message-ID: <yw1xhc3f5xb9.fsf@thrashbarg.mansr.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Thu, Jan 29, 2009 at 11:29:31PM -0700, Paul Walmsley wrote:
>> On Thu, 29 Jan 2009, Russell King - ARM Linux wrote:
>> 
>> > On Wed, Jan 28, 2009 at 12:18:16PM -0700, Paul Walmsley wrote:
>> > > From: Mans Rullgard <mans@mansr.com>
>> > > 
>> > > This makes clk_get_parent() work on OMAP2/3.
>> > 
>> > This is clearly something that the generic code should be doing.
>> > It's not something specific to OMAP2/3.  Please move it to
>> > arch/arm/plat-omap/clock.c
>> 
>> Done; revised patch below.
>
> Great, thanks.  However, I'd forgotten that one of my patches completely
> removes clk_get_parent() since it's unused by any code in OMAP at present.
>
> What was the reasoning behind making this work?

It is needed for the omapfb/dss driver to set an optimal rate for
dpll4_m4_ck.

-- 
Måns Rullgård
mans@mansr.com
