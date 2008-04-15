Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbYDOMrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbYDOMrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYDOMrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:47:07 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:51137 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYDOMrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:47:05 -0400
Message-ID: <4804A3B9.6000601@panasas.com>
Date: Tue, 15 Apr 2008 15:46:49 +0300
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Martin Knoblauch <spamtrap@knobisoft.de>
CC: linux-kernel@vger.kernel.org, am-utils <am-utils@am-utils.org>
Subject: Re: User space automounter problems after upgrade to 2.6.25-rc9
References: <313568.49494.qm@web32607.mail.mud.yahoo.com>
In-Reply-To: <313568.49494.qm@web32607.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
> Hi,
> 
>  after booting a newly built 2.6.25-rc9 kernel, I see the following messages and the user space automounter fails to work. Last good kernel for me is 2.6.24, as -rc9 is my first attempt at 2.6.25. Extremely sorry for being late to the game :-(
> 
> [   13.776876] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   11.996757] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   14.504927] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   14.504927] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   14.505079] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   11.996757] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   12.688801] Invalid hostname "pid4302@lpsdm60:/soft" in NFS lock request
> 
> am-utils version is 6.1.5, config is attached
> 
> Cheers
> Martin
> ------------------------------------------------------
> Martin Knoblauch
> email: k n o b i AT knobisoft DOT de
> www:   http://www.knobisoft.de
> 

Martin, thanks for the report.
This is a known problem.
See http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/2f45e12c9e4e41a2/344607c434ea1040

Benny
