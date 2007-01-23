Return-Path: <linux-kernel-owner+w=401wt.eu-S932947AbXAWKlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbXAWKlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 05:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXAWKlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 05:41:50 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4948 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbXAWKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 05:41:49 -0500
Date: Tue, 23 Jan 2007 10:41:40 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Message-ID: <20070123104140.GA20660@flint.arm.linux.org.uk>
Mail-Followup-To: Alon Bar-Lev <alon.barlev@gmail.com>,
	Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org
References: <20070118125849.441998000@strauss.suse.de> <20070118130028.719472000@strauss.suse.de> <20070118141359.GB31418@flint.arm.linux.org.uk> <45AF92E7.50901@dbservice.com> <20070118152326.GC31418@flint.arm.linux.org.uk> <20070122221400.GE6262@strauss.suse.de> <20070122222725.GB32085@flint.arm.linux.org.uk> <9e0cf0bf0701230237j5aa1bbya3a70da314e471b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e0cf0bf0701230237j5aa1bbya3a70da314e471b9@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 12:37:06PM +0200, Alon Bar-Lev wrote:
> On 1/23/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >which reflects precisely what I've been saying concerning the addition
> >of __initdata.
> 
> Great!
> So what do you thing we should do?
> 
> Modify this:
> char __initdata boot_command_line[COMMAND_LINE_SIZE];
> 
> Into:
> char __initdata boot_command_line[COMMAND_LINE_SIZE] = {0};
> 
> Or:
> static char __initdata _boot_command_line[COMMAND_LINE_SIZE];
> char __initdata *boot_command_line = _boot_command_line;
> 
> Or any other option... I will glad to receive any convention you see right.

See Message-ID: <20070118152326.GC31418@flint.arm.linux.org.uk> sent on
18 January in this thread.  Such strings might as well be initialised to
an empty string.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
