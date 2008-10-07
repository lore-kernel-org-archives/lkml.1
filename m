Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYJGQOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYJGQOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYJGQOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:14:33 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60218 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbYJGQOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:14:32 -0400
Date: Tue, 7 Oct 2008 09:14:22 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH v2] proc: show personality via /proc/pid/personality
Message-ID: <20081007161422.GD10357@outflux.net>
References: <20081002211424.GJ10632@outflux.net> <20081004145149.52c34ee7@infradead.org> <20081004220220.GK10632@outflux.net> <20081004164239.0c1483a4@infradead.org> <20081005004233.GL10632@outflux.net> <20081004174843.6fe48a8e@infradead.org> <20081005091120.GA21003@x200.localdomain> <20081005101438.GR10632@outflux.net> <517f3f820810070639q549ed2a1pe297e45108dfa007@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517f3f820810070639q549ed2a1pe297e45108dfa007@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, Oct 07, 2008 at 03:39:26PM +0200, Michael Kerrisk wrote:
> On Sun, Oct 5, 2008 at 12:14 PM, Kees Cook <kees.cook@canonical.com> wrote:
> > Make process personality flags visible in /proc.  Since a process's
> > personality is potentially sensitive (e.g. READ_IMPLIES_EXEC), make this
> > file only readable by the process owner.
> 
> Please CC userland interface changes to linux-api@vger.kernel.org

Sure, I'd be happy to do that for future stuff.  I don't see this email
address mentioned anywhere in the kernel tree.  It seems like this is
useful information that should go in either MAINTAINERS or better yet
Documentation/SubmittingPatches for it to be discoverable by future
patch-senders -- and somewhere that I can look it up easily later.  :)

-Kees

-- 
Kees Cook
Ubuntu Security Team
