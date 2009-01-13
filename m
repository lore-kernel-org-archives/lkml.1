Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbZAMM5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbZAMM5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbZAMM5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:57:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:10842 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbZAMM5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hH3WxaoR8OEyHNgIc/wgscIV+hFrAow61kUybskWugE+YNbpuPe1TGLYRUVmFZjsHB
         WMwl3l/lHjpQfSME/xrxLksswmCwL4gDfuWGjyIaJnfuwJ+uD4+zxSBRidDJFgqAUWPl
         PH4yqPg3NNSGsF+ZmN/8Vdr1OAeRUiCqk22II=
Date: Tue, 13 Jan 2009 15:57:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - include linux/types.h instead of
	asm/types.h
Message-ID: <20090113125705.GC7682@localhost>
References: <20090113120905.GB7682@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113120905.GB7682@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Jan 13, 2009 at 03:09:05PM +0300]
| Impact: cleanup
| 
| 'make headers_check' warns that linux/types.h is
| preferred over asm/types.h. So be it.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| CC: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| CC: Sam Ravnborg <sam@ravnborg.org>
| CC: Harvey Harrison <harvey.harrison@gmail.com>
| ---
| 
|  arch/x86/include/asm/e820.h       |    2 ++
|  arch/x86/include/asm/kvm.h        |    2 +-
|  arch/x86/include/asm/mce.h        |    2 +-
|  arch/x86/include/asm/mtrr.h       |    1 +
|  arch/x86/include/asm/ptrace-abi.h |    2 +-
|  arch/x86/include/asm/sigcontext.h |    2 +-
|  arch/x86/include/asm/swab.h       |    2 +-
|  7 files changed, 8 insertions(+), 5 deletions(-)
|
...

well... on the other hand I'm not sure if it's really
a good idea to include linux/types.h where we need only
__u[8,16] and so on definitions.

Ingo, don't apply this patch please -- have to check
for other ways.
 
		- Cyrill -
