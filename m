Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbZAMNM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbZAMNM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZAMNMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:12:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:16866 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZAMNMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sVxdMwhW+PP/FkkNZ2Vkpng1iFFMdFR2hn/2mD91rFdN8PfzFfXl6xGUzPWdZWKr+R
         32ew3nJ/abpMizuS9JohFJTINjPutFsE87+3k6pSZPEUAdJDS/3BrtXm+ZNbe7YjtZRO
         YYAeIXS9DUXMDFHdn041Ts278L0ICdrOQBOl8=
Date: Tue, 13 Jan 2009 16:12:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - include linux/types.h instead of
	asm/types.h
Message-ID: <20090113131215.GE7682@localhost>
References: <20090113120905.GB7682@localhost> <20090113125705.GC7682@localhost> <3f9a31f40901130508w7e7c1be8gac25e019e6430858@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901130508w7e7c1be8gac25e019e6430858@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jaswinder Singh Rajput - Tue, Jan 13, 2009 at 06:38:02PM +0530]
| On Tue, Jan 13, 2009 at 6:27 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > [Cyrill Gorcunov - Tue, Jan 13, 2009 at 03:09:05PM +0300]
| > | Impact: cleanup
| > |
| > | 'make headers_check' warns that linux/types.h is
| > | preferred over asm/types.h. So be it.
| > |
| > | Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > | CC: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| > | CC: Sam Ravnborg <sam@ravnborg.org>
| > | CC: Harvey Harrison <harvey.harrison@gmail.com>
| > | ---
| > |
| > |  arch/x86/include/asm/e820.h       |    2 ++
| > |  arch/x86/include/asm/kvm.h        |    2 +-
| > |  arch/x86/include/asm/mce.h        |    2 +-
| > |  arch/x86/include/asm/mtrr.h       |    1 +
| > |  arch/x86/include/asm/ptrace-abi.h |    2 +-
| > |  arch/x86/include/asm/sigcontext.h |    2 +-
| > |  arch/x86/include/asm/swab.h       |    2 +-
| > |  7 files changed, 8 insertions(+), 5 deletions(-)
| > |
| > ...
| >
| > well... on the other hand I'm not sure if it's really
| > a good idea to include linux/types.h where we need only
| > __u[8,16] and so on definitions.
| >
| > Ingo, don't apply this patch please -- have to check
| > for other ways.
| >
| 
| I am attaching usr/include/linux/types.h for your reference which
| includes all these definations for userspace.
| 
| Thanks
| --
| JSR

yeah, thanks! I already have one in my git clone but anyway ;-)

		- Cyrill -
