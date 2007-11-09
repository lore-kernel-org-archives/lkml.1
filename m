Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbXKIWbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbXKIWbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbXKIWbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:31:10 -0500
Received: from station18k.dscga.com ([192.24.222.18]:57001 "EHLO
	suzuka.mcnaught.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbXKIWbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:31:09 -0500
X-Greylist: delayed 2220 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2007 17:31:09 EST
To: "Tobias Brox" <tobixen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOM killer problem - how to read the kernel log?
References: <ef2af3100711091335y35c3d514u4faec75528fcec5b@mail.gmail.com>
From: Douglas McNaught <doug@mcnaught.org>
Date: Fri, 09 Nov 2007 16:54:08 -0500
In-Reply-To: <ef2af3100711091335y35c3d514u4faec75528fcec5b@mail.gmail.com> (Tobias
 Brox's message of "Fri, 9 Nov 2007 22:35:14 +0100")
Message-ID: <87k5orf5kv.fsf@suzuka.mcnaught.org>
User-Agent: Gnus/5.1006 (Gnus v5.10.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Tobias Brox" <tobixen@gmail.com> writes:

> We have a database server which we've had some problems with, we've
> had some serious crashes (particularly during postgres vacuuming)
> which couldn't be fixed without hardware reboot.  We assumed that the
> problem would go away by itself after upgrading the server to a new
> box with 32G of RAM ... but, alas, one of the first days in operation
> it first killed lots of postgres children during the evening, and
> finally it crashed and required hardware reboot.  The box is certainly
> not out of memory, but after reading some posts here, I've understood
> that memory management is a complex issue.
>
> We're running 32 bits linux, maybe it would help to upgrade to 64 bits?

Big-time.  There are a lot of "artificial" internal kernel memory
limits in the 32-bit architecture, so you can run up against those
(triggering the OOM killer) even if you have plenty of application
memory.

32GB in the box actually might be counter-productive unless you're
running 64-bit, because just tracking that much memory will consume
precious low kernel RAM.

-Doug
