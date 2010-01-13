Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918Ab0ANPDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0ANPDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907Ab0ANPCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:02:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49820 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab0ANPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:02:51 -0500
Date: Wed, 13 Jan 2010 21:23:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-news@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100113202333.GB1572@ucw.cz>
References: <201001111007.EAG82373.VHFQSLFOFMOOJt@I-love.SAKURA.ne.jp> <20100111174922.GA17285@us.ibm.com> <hiif50$l7r$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hiif50$l7r$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please fix your email settings.

On Tue 2010-01-12 18:30:56, David Wagner wrote:
> Serge E. Hallyn wrote:
> >Michael, I'm sorry, I should go back and search the thread for the
> >answer, but don't have time right now - do you really need
> >disablenetwork to be available to unprivileged users?
> 
> I don't know about Michael's specific case, but answering more
> broadly, Yes.  There are important use cases for disablenetwork for
> unprivileged users.  Basically, it facilitates privilege separation,
> which is hard to do today.  A privilege-separated software architecture
> is useful for a broad variety of programs that talk to the network --
> some/many of which are unprivileged.  For instance, the very original
> post on this topic referred to a proposal by Dan Bernstein, where Dan
> points out that (for instance) it would make be useful if we could start
> a separate process for decompression (or image file transformation),
> running that separate process with no privileges (including no network
> access) to reduce the impact of vulnerabilities in that code.  Think
> of, say, a browser that needs to convert a .jpg to a bitmap; that
> would be an example of an unprivileged program that could benefit
> from the disablenetwork feature, because it could spawn a separate
> process to do the image conversion.

That's still ok; but is there need for unpriviledged helper executing
setuid probgrams? I don't think so...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
