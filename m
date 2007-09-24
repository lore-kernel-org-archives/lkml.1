Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbXIXHr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbXIXHr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXIXHrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:47:51 -0400
Received: from gw.goop.org ([64.81.55.164]:57861 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbXIXHrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:47:51 -0400
Message-ID: <46F76BA6.8030002@goop.org>
Date: Mon, 24 Sep 2007 00:47:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: osth@freesurf.ch
CC: linux-kernel@vger.kernel.org
Subject: Re: Xen kernel 2.6.23-rc7 bug at xen_mc_flush (arch/i386/xen/multicalls.c:68)
References: <46E1184D0000CFD8@mta-fs-be-07.sunrise.ch>
In-Reply-To: <46E1184D0000CFD8@mta-fs-be-07.sunrise.ch>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

osth@freesurf.ch wrote:
> Using kernel 2.6.23-rc7 as xen domU client system I observe a kernel bug
> which occurs reproducibly when calling a shell from midnight commander F2
> context menu or with testcase given below  (However most other programs seem
> to
> be well behaved and do not trigger this bug). - A kernel compiled with debug
> info gives:
>   

OK, I think I've seen this before, and need to track it down.  Could you
try again with a kernel with debug info, and does anything relevant
appear in "xm desg"?

Thanks,
    J
