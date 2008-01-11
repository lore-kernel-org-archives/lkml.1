Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbYAKKmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbYAKKmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYAKKmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:42:08 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:33193 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755860AbYAKKmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:42:06 -0500
Date: Fri, 11 Jan 2008 19:41:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080111104144.GA31709@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ralf Baechle <ralf@linux-mips.org>, Adrian Bunk <bunk@kernel.org>,
	linux-kernel@vger.kernel.org
References: <20080101134809.GK2360@does.not.exist> <20080110221845.GB20875@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110221845.GB20875@linux-mips.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 10:18:45PM +0000, Ralf Baechle wrote:
> On Tue, Jan 01, 2008 at 03:48:09PM +0200, Adrian Bunk wrote:
> 
> Definately NAK for the MIPS segments.  Some of the EXPERIMENTAL
> dependencies should be removed but many options tagged with EXPERIMENTAL
> are still dangerous.
> 
Likewise for the SH portions. EXPERIMENTAL in these places really does
mean EXPERIMENTAL. BROKEN has very different meanings, as does silently
promoting the offending options to !EXPERIMENTAL.

While EXPERIMENTAL in drivers/ might not have any real meaning, most of
the examples listed for arch/ have been intentional, and I'd wager that
most arch maintainers used it both carefully and intentionally. There's
no reason to punish arch/ for the transgressions of drivers/.

If enough subsystems switch off of EXPERIMENTAL and use a
subsystem-specific EXPERIMENTAL option, then perhaps we can reclaim
EXPERIMENTAL to actually mean what it's supposed to, without worrying
about people just turning it on to get at all of their missing driver
options.
