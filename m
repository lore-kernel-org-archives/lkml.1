Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXKARiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXKARiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbXKARin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:38:43 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:52496 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbXKARim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:38:42 -0400
Subject: Re: [RFC] cpuset relative memory policies - second choice
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, rientjes@google.com,
       linux-kernel@vger.kernel.org, ak@suse.de,
       Michael Kerrisk <mtk-manpages@gmx.net>
In-Reply-To: <20071101102616.826d45a1.pj@sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
	 <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
	 <20071031131949.b91bf383.pj@sgi.com>
	 <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
	 <20071031214719.81f8293a.pj@sgi.com>
	 <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
	 <20071031233352.959c32d0.pj@sgi.com>
	 <Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com>
	 <20071101090612.e0c86ddb.pj@sgi.com>
	 <Pine.LNX.4.64.0711011006070.29468@schroedinger.engr.sgi.com>
	 <20071101102616.826d45a1.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 01 Nov 2007 13:38:11 -0400
Message-Id: <1193938691.5300.93.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 10:26 -0700, Paul Jackson wrote:
> Christoph wrote:
> > The library interface can set flags to modify behavior.
> 
> A library such as libnuma can set them, yes, but not everyone uses
> libnuma.  Basically everyone uses the standard C library, glibc, which
> has the system call wrappers, but these wrappers should not be setting
> optional flags.
> 
> We're going around in circles here, Christoph.

I think that the syscall man pages can document the behavior mode flag
for folks who want to use the "raw" interface.  I think we already
recommend the use of libnuma APIs.  [If not we can make it so, if folks
agree.]  

So, we default to old behavior in the raw syscall APIs--we MUST, right?
"no breaky user APIs..."--and let new version of the library/ies enable
new behavior when appropriate.  Even a "new syscall", such as the
set_mempolicy2(), et al that you suggested, could be just wrappers over
the existing ones with the behavior mod flag.  Or vice versa.  

Lee



