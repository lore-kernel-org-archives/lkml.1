Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbYB0UnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbYB0UnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759854AbYB0UnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:43:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35545 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759792AbYB0UnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:43:09 -0500
Date: Wed, 27 Feb 2008 21:43:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: Re: [PATCH] x86 vdso: fix build locale dependency
Message-ID: <20080227204321.GA13309@uranus.ravnborg.org>
References: <20080227194215.0B5A32700FD@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227194215.0B5A32700FD@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:42:15AM -0800, Roland McGrath wrote:
> 
> Priit Laes discovered that the sed command processing nm output was
> sensitive to locale settings.  This was addressed in commit
> 03994f01e8b72b3d01fd3d09d1cc7c9f421a727c by using [:alnum:] in place of
> [a-zA-Z0-9].  But that too is locale-dependent and may not always match
> the identifiers it needs to.  The better fix is just to run sed et al
> with a fixed locale setting in all builds.

Priit's original patch used the LC_ALL trick. It is
me to blame that it was replaced with [:alnum:] :-(

	Sam
