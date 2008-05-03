Return-Path: <linux-kernel-owner+w=401wt.eu-S1764629AbYECP7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764629AbYECP7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbYECP7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:59:11 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:38653
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752837AbYECP7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:59:10 -0400
Date: Sat, 3 May 2008 08:59:09 -0700
From: Phil Oester <kernel@linuxace.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roth <ryanroth@sbcglobal.net>, Ryan.Roth@CH2M.com,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting With 2.6.24.5 Kernel
Message-ID: <20080503155909.GA23105@linuxace.com>
References: <20080501133003.be723364.akpm@linux-foundation.org> <86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com> <481A5276.4040607@sbcglobal.net> <20080501170239.9b740877.akpm@linux-foundation.org> <481A5A94.2080400@sbcglobal.net> <20080501173408.384b4fc3.akpm@linux-foundation.org> <20080502020815.GA5155@linuxace.com> <20080501192838.8ecb81c2.akpm@linux-foundation.org> <20080502121945.GA18667@linuxace.com> <20080502061018.5557d067.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502061018.5557d067.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 06:10:18AM -0700, Andrew Morton wrote:
> Traditionally i386 never printed that message (in fact neither architecture
> should - it allows poeple to spam the logs, but it is at least
> ratelimited).
> 
> In 2.6.23, i386 _does_ generate that message, in arch/i386/mm/fault.c
> 
> In 2.6.24 the i386 and x86_64 fault handlers were renamed to
> arch/x86/mm/fault_[32|64].c and both versions generated the message.
> 
> In 2.6.25 they were unified into a single arch/x86/mm/fault.c, and both
> architectures print the message.
> 
> So afacit 2.6.23 _should_ be printing the message if qmail is indeed
> generating a segfault.  But there's always the possibility that the
> message-printing code was simply broken in 2.6.23, and that your qmail has
> always been generating segfaults.

That is the most likely scenario.  I tried out 2.6.23, and it generates
the segfaults also.  And we're running a patched qmail-smtpd, so it likely
has been segfaulting "forever", but only became noticable in 2.6.23+.

Sorry for the noise.

Phil
