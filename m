Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbXKGWGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbXKGWGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758545AbXKGWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:05:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758393AbXKGWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:05:56 -0500
Date: Wed, 7 Nov 2007 14:04:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Cc: bugme-daemon@bugzilla.kernel.org,
       Samuel Thibault <samuel.thibault@ens-lyon.org>, hannibal@astral.lodz.pl,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Bill Nottingham <notting@redhat.com>
Subject: Re: [Bugme-new] [Bug 9319] New: National characters are not
 displayed under console.
Message-Id: <20071107140450.fc6a5cb5.akpm@linux-foundation.org>
In-Reply-To: <bug-9319-10286@http.bugzilla.kernel.org/>
References: <bug-9319-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed,  7 Nov 2007 13:19:16 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9319
> 
>            Summary: National characters are not displayed under console.
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.24-rcX
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Console/Framebuffers
>         AssignedTo: jsimmons@infradead.org
>         ReportedBy: hannibal@astral.lodz.pl
> 
> 
> Most recent kernel where this bug did not occur: 2.6.23
> 
> Distribution: Slackware
> 
> Hardware Environment:
> Toshiba Tecra M1
> Pentium M 1.6 512MB RAM, ICH4-M chipset, Trident CyberBlade XP4 video card
> 
> Software Environment: Slackware-current (kbd-1.12, glibs 2.5)
> 
> Problem Description:
> The national characters like "ą", "ł" or "ż" are not displayed corectlly
> under console (no matter vesa framebuffer, or standard vga). Instead of them
> "?" on strange background is displayed. Problem begins on 2.6.24-rc1 and
> continues on 2.6.24-rc2. On 2.6.23 everything is OK.
> 
> Steps to reproduce:
> Run 2.6.24-rcX kernel and set national console font by setfont.
> 

Another post-2.6.23 regression.  Possible culprits cc'ed?
