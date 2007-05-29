Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbXEaKUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbXEaKUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXEaKUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:20:09 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:38442 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbXEaKUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:20:08 -0400
Date: Tue, 29 May 2007 13:35:57 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Trent Waddington <trent.waddington@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Portable syscall inspection
Message-ID: <20070529123557.GA21684@linux-mips.org>
References: <3d57814d0705281559y56576567r2c23edda5f22c3cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d57814d0705281559y56576567r2c23edda5f22c3cf@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 08:59:37AM +1000, Trent Waddington wrote:

> Someone finally noticed that my program that uses ptrace only works on 
> i386..
> and, by the looks of it, there is no portable way to refer to the
> registers of a
> user_regs_struct when inspecting a system call.

Correct.

> I will probably end up making a header file for each architecture that
> defines where
> in the user_regs_struct things like the syscall number, the return
> value and the first 3 parameters are..

Also consider that some architectures pass parts of the arguments in
registers which on yet others are passed in memory.  Sometimes padding
arguments are needed and many more oddities.  Similar for results.
Inescapably such a program is a perment maintenance nightmare.

> has anyone done this already?  or can otherwise save me a lot of time?

Similar things have been tried before but nothing that would be remotely
sane.

  Ralf
