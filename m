Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbZLGBkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbZLGBkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 20:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbZLGBkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 20:40:05 -0500
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:55560 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758046AbZLGBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 20:40:04 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2009 20:40:04 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RGi9acktCBBDtghiJ1WhT1jVWT7YBK2qpRUncJv3uDN1w7Nssv5nzwLIWHEFowDuSx8w6vv3ELYJfFeBWASwHGLJ9xubxYyTC/RUMpkO+wz/wt5988VsuC7c1Sezqsry;
Date: Sun, 6 Dec 2009 17:32:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       luto@myrealbox.com, benisty.e@gmail.com
Subject: Re: 2.6.31 -> 2.6.32 Sound and video regressions
Message-ID: <20091206173222.4c2d5aaa@jbarnes-piketon>
In-Reply-To: <50CA8D92EC%linux@youmustbejoking.demon.co.uk>
References: <4B1A6F78.8010408@myrealbox.com>
	<50CA8D92EC%linux@youmustbejoking.demon.co.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Dec 2009 23:44:55 +0000
Darren Salt <linux@youmustbejoking.demon.co.uk> wrote:

> I demand that Andy Lutomirski may or may not have written...
> 
> > Emmanuel Benisty wrote:
> [snip]
> >> I just wanted to report 2 regressions I am having now with 2.6.32.
> >> Video
> >> Screen is flickering/glitching like crazy in X. It happens whether
> >> randomly or when conky is refreshed, when the mouse cursor moves
> >> and like hell when a page is loading in the browser. Not so easy to
> >> describe this issue.
> [snip]
> 
> > That sounds like FIFO underruns, which (I think) were introduced
> > when self-refresh was enabled but should have been fixed. I
> > personally have no clue how to fix them, but if you told the Intel
> > people what kind of chip you have (lspci output), they can probably
> > fix it.
> 
> It also sounds like what I'm seeing on my EeePC 901. It only happens
> after resume, which makes STR a little less than useful; the display
> will, sooner or later, show a single colour (which is, presumably,
> the result of a display engine hang, as described in the comment
> immediately before intel_calculate_wm) and, seemingly, be stuck like
> that until power-off or reboot.
> 
> Whether it *is* the same problem, I couldn't say.
> 
> Needless to say, this problem goes away if I disable KMS.

Arg, there are a few reports of this now, but I haven't been able to
reproduce it.  I'll try harder...  (FYI the upstream
bugs.freedesktop.org # for it is 24314).

-- 
Jesse Barnes, Intel Open Source Technology Center
