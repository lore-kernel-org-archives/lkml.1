Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbZBSPRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbZBSPRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZBSPQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:16:44 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:63967 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbZBSPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:16:44 -0500
Message-ID: <499D77D8.509@cfl.rr.com>
Date: Thu, 19 Feb 2009 10:16:40 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <498C7980.2060309@compro.net> <498CB798.7050308@cfl.rr.com> <20090209141841.GA31643@aftab> <49904BED.7090208@cfl.rr.com> <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com>
In-Reply-To: <20090219141131.GM4301@alberich.amd.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> Hi Mark,
> 
> Can you please provide us output of lspci -vvxxx.
> (Please run this as root.)
> 
> Furthermore you can try booting your 1000HZ kernel
> with following kernel command lines:
> 
> (1) acpi_skip_timer_override apic=debug
> (2) nohpet apic=debug
> (3) acpi_skip_timer_override nohpet apic=debug
> 
> and send us all dmesg output.
> 
> 
> Thanks!
> 
> Andreas
> 

Should I leave the leave the immediate return I put in the check_hlt routine or
set it back to normal first?

Mark
