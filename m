Return-Path: <linux-kernel-owner+w=401wt.eu-S1763108AbXEVG6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763108AbXEVG6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXEVG6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:58:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52127 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbXEVG6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:58:37 -0400
Date: Tue, 22 May 2007 06:43:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Collins <ben.collins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [RFC] Crash on modpost, addend_386_rel()
Message-ID: <20070522044348.GB7795@uranus.ravnborg.org>
References: <1179799287.7485.17.camel@cunning>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179799287.7485.17.camel@cunning>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 10:01:27PM -0400, Ben Collins wrote:
> Got this crash in modpost. Bisect blames this commit:
> 
> commit f892b7d480eec809a5dfbd6e65742b3f3155e50e
> Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp> 
> Date:   Thu May 17 01:14:38 2007 +0900
>     kbuild: make better section mismatch reports on i386, arm and mips
> 
>     On i386, ARM and MIPS, warn_sec_mismatch() sometimes fails to show
>     usefull symbol name.  This is because empty 'refsym' due to 0 r_addend
>     value.  This patch is to adjust r_addend value, consulting with
>     apply_relocate() routine in kernel code.
> 
> Sorry, I don't know enough about the elf stuff to fix this up myself.
> Config that causes it is at the end.

Thanks. Linus already reported the same in private mail and I asked him to
revert this commit which he has done by now.
When properly fixed it will be re-added but this time it will cook
a little in -mm first.

	Sam
