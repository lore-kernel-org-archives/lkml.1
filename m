Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYIRHKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYIRHKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYIRHJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:09:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYIRHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cW/7VwsqkOGeLJppomKc31oAeKg3aEaX1qJXM5CoOdYhE4VhDCqHLruqjyc0bouTeg
         sW8bHMap74TlmoPeaQVNOcGUeEh0/J1c4hmiXogm7VJoOrfY6E5uEUmYRokXugPC1G9u
         WccDiLJvGwMNlzCQq4egvIJBU5Dcq+JliV694=
Date: Thu, 18 Sep 2008 11:09:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: j_kernel@hoblitt.com
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080918070947.GA7800@lenovo>
References: <20080917024312.GA23209@hoblitt.com> <20080917071357.GA7455@lenovo> <20080917092058.GB23209@hoblitt.com> <20080917162704.GE7309@lenovo> <20080917204850.GC23209@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917204850.GC23209@hoblitt.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[j_kernel@hoblitt.com - Wed, Sep 17, 2008 at 10:48:50AM -1000]
| On Wed, Sep 17, 2008 at 08:27:04PM +0400, Cyrill Gorcunov wrote:
| > Joshua, could you please do one more thing - boot the kernel
| > with "debug apic=debug nmi_watchdog=1" (among others) and
| > publish dmsg?
| 
| dmesg from "debug apic=debug nmi_watchdog=2" is attached.
|                                           ^
| 
| -J
| 
| --
...

No Joshua, exactly 'nmi_watchdog=1' since it's important to
find who is responsible that cpu is stuck while testing nmi
watchdog. 'debug and apic=debug' will show additional info
what is happening. And it would be just great if you able
to try latest -tip/master

	http://people.redhat.com/mingo/tip.git/README

since there a lot of work/fix are done. If it's a problem
to fetch this kernel thru git - me or Ingo (I suppose)
could make tar.bz2 archive so you'll not need to fetch
the whole history. I wouldn't say I'm really specialist
in this area so your report could be quite important
not for me only but for others too.

		- Cyrill -
