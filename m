Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbXJDV7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbXJDV7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbXJDV7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:59:03 -0400
Received: from mx1.lost-oasis.net ([212.85.153.8]:47092 "EHLO
	mx1.lost-oasis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbXJDV7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:59:01 -0400
Date: Thu, 4 Oct 2007 23:58:57 +0200
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ollie Wild <aaw@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
Message-ID: <20071004215857.GA29513@bigip.bigip.mine.nu>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ollie Wild <aaw@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <m3wsu2u7y6.fsf@bigip.mine.nu> <1191518270.5574.21.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191518270.5574.21.camel@lappy>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w
	3:{EoxBR
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 07:17:50PM +0200, Peter Zijlstra wrote:
> what happens if you up the stack limit to say 128M ?
> 
> Also, do you happen to have execve syscall audit stuff enabled?

Actually, you were right, not only it's enabled but it's also the
culprit.  If I stop it, all is well...

Sorry for the noise.

-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
