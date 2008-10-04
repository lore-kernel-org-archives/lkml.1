Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYJDTov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYJDTov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYJDTom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:44:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:12682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYJDTol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SGeSdLCAHJrny/h8TvKQbUUW30NHKzRxnrFMj+AMXjSyilchRgJBIvhefKVfDmK0Fp
         6z9PuESA4u7+akveIfRGNYb4CwwX16lGCKLNgNsv/DRu6/nnFoDuqvRv3MmrMSpFbDHO
         uRWw3YXPCeUdiuxXYwI0+PHh/cktpo+fRUJ6o=
Date: Sat, 4 Oct 2008 23:44:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Joshua Hoblitt <j_kernel@hoblitt.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11543] kernel panic: softlockup in tick_periodic() ???
Message-ID: <20081004194439.GB16961@localhost>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.M0H.c575IB@wind>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yWwteD.A.M0H.c575IB@wind>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rafael J. Wysocki - Sat, Oct 04, 2008 at 07:32:52PM +0200]
| This message has been generated automatically as a part of a report
| of recent regressions.
| 
| The following bug entry is on the current list of known regressions
| from 2.6.26.  Please verify if it still should be listed and let me know
| (either way).
| 
| 
| Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11543
| Subject		: kernel panic: softlockup in tick_periodic() ???
| Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
| Date		: 2008-09-11 16:46 (24 days old)
| References	: http://marc.info/?l=linux-kernel&m=122117786124326&w=4
| Handled-By	: Thomas Gleixner <tglx@linutronix.de>
| 		  Cyrill Gorcunov <gorcunov@gmail.com>
| 		  Ingo Molnar <mingo@elte.hu>
| 
| 

Joshua is testing -rc8 now. He said (in bugzilla entry):
>
> -rc8 proved itself stable for a few days on two test nodes and it's being
> rolled out onto 32 nodes production nodes as I type this.  The bug strikes
> somewhat randomly so it'll take time for it to pop up in -rc8 if it's still
> there.  Heavy jobs will be running over the weekend and should trip this
> issues if it's still in there...
>

So we're waiting for his verdict.

		- Cyrill -
