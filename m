Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939Ab0A0SBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0A0SBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911Ab0A0SB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:01:29 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:54423 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755865Ab0A0SB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:01:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FCV4VNqqA4hAlZ9f6ZPLZKq+5kHueZ/OnG1576h3Df2puY4tf8z/IY9V2qf0voISqGsoXnsy1NSUcex/8CdBY7gnzp//iwDdhinNLt4pPx3xBiTlO15zjeL4r6tDG2Ro;
Date: Wed, 27 Jan 2010 10:01:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [Bug #14939] drm: random hang with i915
Message-ID: <20100127100109.525b3da6@jbarnes-piketon>
In-Reply-To: <q60Z28d_9yH.A.eK.gZMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	<q60Z28d_9yH.A.eK.gZMXLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010 23:23:04 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14939
> Subject		: drm: random hang with i915
> Submitter	: Arnd Bergmann <arnd@arndb.de>
> Date		: 2009-12-07 17:30 (49 days old)
> References	: http://marc.info/?l=linux-kernel&m=126020704125723&w=4
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> 

Any news on this one Arnd?  Does i915.powersave=0 still fix it?  If so
the bug David found and fixed may have an effect.  Apparently the
hardware wasn't automatically disabling self-refresh mode when multiple
pipes were active (though maybe you didn't have this config?), which
could definitely cause problems.

-- 
Jesse Barnes, Intel Open Source Technology Center
