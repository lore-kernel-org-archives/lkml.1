Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbYDDBSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbYDDBSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYDDBSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:18:06 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:49274 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYDDBSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:18:05 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 21:18:05 EDT
Date: Thu, 3 Apr 2008 22:10:53 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pallipadi@ogre.sisk.pl, Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n -
	Apple
Message-ID: <20080404011053.GA21254@localhost.ift.unesp.br>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.AOB.6GW9HB@albercik> <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu  3.Apr'08 at 17:14:22 -0700, Pallipadi, Venkatesh wrote:
> >The following report is on the current list of known regressions
> >from 2.6.24.  Please verify if the issue is still present in the
> >mainline.
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
> >Subject		: 2.6.25-current-git hangs on boot 
> >unless CONFIG_CPU_IDLE=n - Apple
> >Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> >Date		: 2008-02-23 18:55 (41 days old)
> >References	: http://lkml.org/lkml/2008/2/23/263
> >		  
> >http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
> >Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> >
> 
> Last comment I saw from Soeren says it does not really hang. It waits
> for 5-10 seconds sometimes before continuing. We are still trying to
> narrow this down with max_cstate etc..

I should say that my laptop (Vaio) _hangs_ at boot (less than 10% of boots)
and this is the last message I see:

"ACPI: Processor [CPU1] (supports 8 throttling states)"

and it stays there "forever" (more than 1 or 2 minutes at least).

I am not using my laptop too much these days, and I thought this
bug had been solved because it didn't hang for the last week (but
I boot it once per day), however it hang last night (using some
post 2.6.25-rc7 kernel)

I have pictures of the screen while showing this last message at boot, 
should I post it somewhere or that is not necessary?.
