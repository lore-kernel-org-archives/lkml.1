Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYCQWan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYCQWan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYCQWad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:30:33 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:40776 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYCQWac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:30:32 -0400
Message-ID: <47DEF13F.4000703@keyaccess.nl>
Date: Mon, 17 Mar 2008 23:31:27 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: trenn@suse.de
CC: Len Brown <lenb@kernel.org>, Dave Jones <davej@codemonkey.org.uk>,
       linux-acpi@vger.kernel.org, Adam M Belay <abelay@mit.edu>,
       Zhao Yakui <yakui.zhao@intel.com>, Li Shaohua <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PNP: dynamic pnp resources
References: <20080312151452.GA4523@codemonkey.org.uk>	 <200803121345.21297.lenb@kernel.org> <1205409848.29877.358.camel@queen.suse.de>
In-Reply-To: <1205409848.29877.358.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-08 13:04, Thomas Renninger wrote:

> I had the problem that I could not test on isa systems.

Perhaps we can go organize a fundraiser for SuSE so they can go out and buy 
an ISAPnP soundcard. I have a few I can sell. I promise I won't overcharge 
them (much).

> Rene Herman helped here a lot.
> There are still open issues, last state was (comment from Rene):
> ------------------------
> No. Please note we're talking about ISAPnP, not PnPBIOS. No BIOS
> involved at all.
> 
> Driver (sound/isa/cs423x/cs4236.c) furthermore does not use anything but
> the PnP layer itself. Start at snd_cs423x_pnpc_detect, which is the
> pnp .probe() method.
> 
> I'll look into providing a more extensive answer and/or test whatever
> comes in later.
> -------------------------

Did look, but decided there wasn't much more specifically to add. It's 
something more fundamental about the flow of things and while the comment 
above is obviously cynical I did grow a bit tired of a series of patches 
that just transported the OOPS two lines down again each time, so I held out 
for Bjorn as well.

Still availabe for tests.

Rene.
