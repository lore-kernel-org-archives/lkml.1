Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYDHMjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYDHMjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 08:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYDHMjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 08:39:47 -0400
Received: from nn7.de ([85.214.94.156]:51718 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYDHMjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 08:39:46 -0400
Subject: Re: 2.6.25-rc6 regression - hang on resume [Bug 10319]
From: Soeren Sonnenburg <kernel@nn7.de>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Tino Keitel <tino.keitel@gmx.de>, "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, Jesse Barnes <jesse.barnes@intel.com>,
       suspend-devel@lists.sourceforge.net
In-Reply-To: <1207658107.21698.17.camel@pern>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <1207290689.4511.1.camel@localhost> <1207552602.26185.13.camel@pern>
	 <200804071110.39933.rjw@sisk.pl>  <20080408085846.GA15403@dose.home.local>
	 <1207658107.21698.17.camel@pern>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Apr 2008 14:39:43 +0200
Message-Id: <1207658383.553.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-08 at 14:35 +0200, Romano Giannetti wrote:
> 
> On Tue, 2008-04-08 at 10:58 +0200, Tino Keitel wrote:
> > With 2.6.25-rc, the text console is fine after resume, due to the
> > recent changes to the Intel i915 DRM driver. Maybe those people who
> > used to use vbetool prior to 2.6.25 should check if this is still
> > needed.
> 
> Yep, the problem is just that: in 2.6.24 vbetool hacks (in my case,
> using s2ram -p -m options) was needed to resume graphics. Now they are
> not needed anymore, and using them _break_ resume.
> 
> So, people with a working suspend-to-ram setup (even using the whitelist
> in s2ram, I mean, simply calling s2ram) will discover that 2.6.25 break
> their machine. Removing the s2ram package and suspending with
> kernel-only machinery will work, but... well, it's not user-friendly.

The above holds only if you have an intel graphics adapter. For me
(radeon) it really breaks (as in echo mem >/sys/power/state leaves me a
black screen on resume and manually typing vbetool post or vbetool
vgamode simply hangs the machine).

Soeren
