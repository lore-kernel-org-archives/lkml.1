Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbYDMU0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbYDMU0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYDMU0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:26:45 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:45164 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbYDMU0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:26:44 -0400
Date: Sun, 13 Apr 2008 17:25:45 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [Bug #10117] 2.6.25-current-git sometimes hangs on boot -
	dual-core Sony Vaio
Message-ID: <20080413202545.GA7111@localhost.ift.unesp.br>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Soeren Sonnenburg <kernel@nn7.de>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.WZB.Z6lAIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oq66hWjeF4N.A.WZB.Z6lAIB@albercik>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 13.Apr'08 at 20:56:41 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.24.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
> Subject		: 2.6.25-current-git sometimes hangs on boot - dual-core Sony Vaio
> Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> Date		: 2008-02-23 18:55 (51 days old)
> References	: http://lkml.org/lkml/2008/2/23/263
> 		  http://lkml.org/lkml/2008/4/4/41
> 		  http://lkml.org/lkml/2008/4/9/69

Soeren said it no longer happens to him in http://lkml.org/lkml/2008/4/9/53
but unfortunately it still happens with me using -rc9. So I kidnapped his 
bugzilla report :-)

In the bugzilla entry I said earlier today that "hpet=disable" apparently
makes the problem go away (42 boots OK so far, whereas without this
boot option it hangs ~90% using vga=6 and ~10% using vga=0x0364)

I tried to bisect it, but sometimes in pre 2.6.25-rc1 kernels it takes
30 boots before the first hang to occur. So bisection is not reliable...

If someone proposes a patch I will be glad to test it!

PS: The similar bug in buzilla 10377 also appears to be "fixed"
by using hpet=disable, see comment #17 in that bug.
