Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbXJ0Xhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbXJ0Xhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 19:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXJ0Xhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 19:37:46 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2206 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbXJ0Xhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 19:37:45 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: tristate and bool not enogh for Kconfig anymore
Date: Sun, 28 Oct 2007 01:37:26 +0200
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, Henrik Carlqvist <hc1@poolhem.se>,
       linux-kernel@vger.kernel.org, bunk@stusta.de
References: <200710201257.55616.nick@ukfsn.org> <20071021174748.92abc989.rdunlap@xenotime.net> <20071021201416.4ccde183.rdunlap@xenotime.net>
In-Reply-To: <20071021201416.4ccde183.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710280137.28128.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 22 October 2007, Randy Dunlap wrote:

> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> Another common idiom that we see (and sometimes have problems
> with) is this:
>
> When B (module or subsystem) uses interfaces from A (module or
> subsystem), A can be linked statically into the kernel image or
> can be built as loadable module(s).   This limits how B can be
> built.  If A is linked statically into the kernel image, B can be
> built statically or as loadable module(s).  However, if A is built
> as loadable module(s), then B must be restricted to loadable
> module(s) also.  This can be expressed in kconfig language as:
>
> config B
> 	depends on A = y || A = B

What you describe is a simple "depends on A" and your example won't work 
because it adds a recursive dependency.

bye, Roman
