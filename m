Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbZDSWpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbZDSWpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZDSWpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:45:06 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37251 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZDSWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:45:04 -0400
Date: Mon, 20 Apr 2009 07:39:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT] kbuild
Message-ID: <20090419223959.GB12054@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Al Viro <viro@ZenIV.linux.org.uk>
References: <20090419092555.GA19213@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419092555.GA19213@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 11:25:55AM +0200, Sam Ravnborg wrote:
> We have on the lists recently discussed two features:
> 1) Move generated files to include/generated
> 2) Introduce support for subdir-ccflags-y
> 
> Both features has low risk of introducing regressions
> and including them now allow us to use the features for next
> merge window.
> 
> This will for example allow arm to support mach-types.h in
> include/generated without touching files outside arch/arm.
> 
This applies to sh also, although apparently I've missed the discussion
about how mach-types.h generation should be using this.
