Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZGIRZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZGIRZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZGIRZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:25:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:24055 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZGIRZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ms1e4acR4N5gVcZUBYZsrd+I3INM4Tk482+lDBs7cdJ/wrSNZtgU8j80n2Svt0vFjI
         ecmXkeDFtubAfW4fQTjgoxT6Ykgi4BuW6RyEmHfWYu0PjdtxXGORVGQq+7OB3voWvhz2
         JM0Pe+mhKy0RTBtDC/pD8BHeQf3Udr10+PlpE=
Date: Thu, 9 Jul 2009 21:25:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/44] includecheck fix: x86, dumpstack.c
Message-ID: <20090709172542.GF5208@lenovo>
References: <1247063308.4382.12.camel@ht.satnam> <1247065025.4382.47.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247065025.4382.47.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jaswinder Singh Rajput - Wed, Jul 08, 2009 at 08:27:05PM +0530]
| 
| fix the following 'make includecheck' warning:
| 
|   arch/x86/kernel/dumpstack.c: linux/ftrace.h is included more than once.
| 
| Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| ---
|  arch/x86/kernel/dumpstack.c |    1 -
|  1 files changed, 0 insertions(+), 1 deletions(-)
| 
| diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
| index c840571..2d8a371 100644
| --- a/arch/x86/kernel/dumpstack.c
| +++ b/arch/x86/kernel/dumpstack.c
| @@ -15,7 +15,6 @@
|  #include <linux/bug.h>
|  #include <linux/nmi.h>
|  #include <linux/sysfs.h>
| -#include <linux/ftrace.h>
|  
|  #include <asm/stacktrace.h>
|  
| -- 
| 1.6.0.6

Looks good to me.
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
 
	-- Cyrill
