Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZAaPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZAaPjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 10:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZAaPjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 10:39:11 -0500
Received: from agrajag.mansr.com ([78.86.181.102]:44002 "EHLO mail.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZAaPjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 10:39:10 -0500
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: Re: [PATCH D 01/11] OMAP: Add clk_get_parent() for OMAP2/3
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
	<20090128191807.16688.91255.stgit@localhost.localdomain>
	<20090129110043.GE12627@n2100.arm.linux.org.uk>
	<alpine.DEB.2.00.0901292327090.26985@utopia.booyaka.com>
	<20090131142344.GM1394@n2100.arm.linux.org.uk>
	<yw1xhc3f5xb9.fsf@thrashbarg.mansr.com>
	<20090131152620.GN1394@n2100.arm.linux.org.uk>
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Sat, 31 Jan 2009 15:39:07 +0000
In-Reply-To: <20090131152620.GN1394@n2100.arm.linux.org.uk> (Russell King's message of "Sat, 31 Jan 2009 15:26:20 +0000")
Message-ID: <yw1x4ozf5vtw.fsf@thrashbarg.mansr.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Sat, Jan 31, 2009 at 03:07:06PM +0000, Måns Rullgård wrote:
>> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
>> > Great, thanks.  However, I'd forgotten that one of my patches completely
>> > removes clk_get_parent() since it's unused by any code in OMAP at present.
>> >
>> > What was the reasoning behind making this work?
>> 
>> It is needed for the omapfb/dss driver to set an optimal rate for
>> dpll4_m4_ck.
>
> I assume this isn't merged yet?  Where can I see what it's doing?

The new DSS driver by Tomi Valkeinen uses it.  Patches have been
posted to the linux-omap list.

-- 
Måns Rullgård
mans@mansr.com
