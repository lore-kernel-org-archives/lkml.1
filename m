Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbXCZSxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbXCZSxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXCZSxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:53:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:27878 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbXCZSxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eeq3OTuVB2jcMkZ1XE+0vUwtU13Lu+LnF6TsyjccKBsiCIEyeErdRR/GCUdsABzC3nBInujpzHN3BjonKomibmdlZkPdtz18yoFo+In3wF3SS4UiGZ/UKbP9dVrjcjBM+m4wgcVrwORgO3Bsbsf3w9+aqwcCviMKAwHnKc7qMwc=
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       Tino Keitel <tino.keitel@gmx.de>, Bob Moore <robert.moore@intel.com>,
       lenb@kernel.org
In-Reply-To: <1174900493.4182.14.camel@chaos>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185022.GQ752@stusta.de>  <1174858456.5550.32.camel@funkylaptop>
	 <1174891519.5550.36.camel@funkylaptop>  <1174900493.4182.14.camel@chaos>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Mar 2007 20:53:20 +0200
Message-Id: <1174935200.5550.43.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 26 mars 2007 à 11:14 +0200, Thomas Gleixner a écrit :
> On Mon, 2007-03-26 at 08:45 +0200, Frédéric RISS wrote:
> > Additional data point: I just tried with -rc5 and the issue is still
> > present. The config I used for this test defines neither NO_HZ nor
> > HIGH_RES_TIMERS.
> 
> Do you have CONFIG_HPET_TIMER enabled and does the box have one ?
> If yes, can you please turn it off and retry ?

Indeed, turning off CONFIG_HPET_TIMER does fix the coming-out-of-suspend
issue. (In fact it hangs at the second suspend, but that's another ATA
problem that I think has already been reported).

Fred.

