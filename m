Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXCTUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXCTUmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXCTUmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:42:54 -0400
Received: from rubis.org ([82.230.33.161]:52316 "EHLO rubis.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbXCTUmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:42:53 -0400
Message-ID: <46004744.5000908@rubis.org>
Date: Tue, 20 Mar 2007 21:42:44 +0100
From: =?ISO-8859-15?Q?St=E9phane_Jourdois?= <kwisatz@rubis.org>
User-Agent: IceDove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kees Cook <kees@outflux.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com> <20070320192016.GC22797@outflux.net>
In-Reply-To: <20070320192016.GC22797@outflux.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook a écrit :
> Gah!  Apologies.  This should fix it, but I can't test it since I can't 
> get 2.6.21-rc4-mm1 to compile (with or without this fix):
> 
>   GEN     .version
> init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> make: *** [.tmp_vmlinux1] Error 2

Hi,

Would you please try the following patch, after removing
init/.missing_syscalls.h.cmd ?

http://lkml.org/lkml/2007/3/20/79

thanks.

- Stéphane.

-- 
 ///  Stephane Jourdois     /"\  ASCII RIBBON CAMPAIGN \\\
(((    Consultant securite  \ /    AGAINST HTML MAIL    )))
 \\\   24 rue Cauchy         X                         ///
  \\\  75015  Paris         / \    +33 6 8643 3085    ///
