Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0CCHvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:51:06 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56230 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab0CCHvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:51:03 -0500
Date: Tue, 2 Mar 2010 23:50:56 -0800
From: Kees Cook <kees.cook@canonical.com>
To: John Johansen <john.johansen@canonical.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 12/12] Kconfig and Makefiles to enable configuration
 and building of AppArmor.
Message-ID: <20100303075056.GS14491@outflux.net>
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
 <1266572188-26529-13-git-send-email-john.johansen@canonical.com>
 <20100222221657.GB22194@us.ibm.com>
 <4B83877D.7030308@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B83877D.7030308@canonical.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 11:45:01PM -0800, John Johansen wrote:
> Serge E. Hallyn wrote:
> > Quoting john.johansen@canonical.com (john.johansen@canonical.com):
> >> From: John Johansen <john.johansen@canonical.com>
> >>
> 
> << snip >>
> 
> >> +config SECURITY_APPARMOR_NETWORK
> >> +       bool "AppArmor network support"
> >> +       depends on SECURITY_APPARMOR
> >> +       default n
> >> +       help
> >> +	 This enables AppArmor to mediate applications network use.
> >> +	 This will enable the SECURITY_NETWORK hooks.
> > 
> > Is there a compelling reason to have SECURITY_APPARMOR_NETWORK?   Does
> > it impact performance?  Is there older userspace that will just break?
> > 
> No, not really anymore.  There used to be a case where I was building
> with network hooks off and this has just been carried forward.
> 
> So it can go along with config APPARMOR_24_COMPAT, and I have even
> been considering pulling the runtime disable as well as I don't
> think there is a case for that either.

Yeah, I'd actually support removing the runtime-disable too; I don't think
I've seen its use in much of the existing AppArmor documentation.

-Kees

-- 
Kees Cook
Ubuntu Security Team
