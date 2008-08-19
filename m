Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYHSQ47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYHSQ47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYHSQ4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:56:51 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54277 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777AbYHSQ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:56:51 -0400
Message-ID: <48AAFB4C.1030300@lwfinger.net>
Date: Tue, 19 Aug 2008 11:56:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rc2 when cross-building the kernel
References: <48A63D98.3070900@lwfinger.net>	 <20080818193253.GA30856@uranus.ravnborg.org>	 <48A9FA05.9000601@lwfinger.net> <20080819044854.GA2276@uranus.ravnborg.org> <1219132135.3184.461.camel@pmac.infradead.org>
In-Reply-To: <1219132135.3184.461.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Tue, 2008-08-19 at 06:48 +0200, Sam Ravnborg wrote:
>> And Larry log say it is so.
>>
>> David - did you have a patch to fix this already?
> 
> The fix was to 'build' the firmware blobs at the same time as 'make
> modules', so that they're already built and don't need to be built at
> modules_install time. That went in a while ago though.
> 
> Why is ihex2fw being rebuilt?
> 

sudo make V=2 modules_install says:

   HOSTCC  firmware/ihex2fw - due to: /usr/include/gnu/stubs-64.h 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include/stddef.h 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/limits.h 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include-fixed/syslimits.h 
/usr/lib64/gcc/x86_64-suse-linux/4.3/include/stdarg.h
/bin/sh: scripts/basic/fixdep: cannot execute binary file
make[1]: *** [firmware/ihex2fw] Error 126
make: *** [_modinst_post] Error 2

Larry

