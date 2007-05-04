Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbXEDPfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbXEDPfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXEDPfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:35:05 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:33050 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030419AbXEDPfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:35:01 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: console font limits
Date: Fri, 4 May 2007 08:34:40 -0700
User-Agent: KMail/1.9.6
Cc: Daniel Hazelton <dhazelton@enter.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com> <200705032358.56055.dhazelton@enter.net> <1178254748.4722.4.camel@daplas>
In-Reply-To: <1178254748.4722.4.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705040834.41000.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 03, 2007, Antonino A. Daplas wrote:
> On Thu, 2007-05-03 at 23:58 -0400, Daniel Hazelton wrote:
> > On Thursday 03 May 2007 20:39:05 H. Peter Anvin wrote:
> > > Kyle Moffett wrote:
> >
> > I guess I could start on that work again - shouldn't take me all that
> > long to recover the stuff I lost when a blackout caused my hard drive
> > to get corrupted beyond recovery (and the automated journal replay
> > didn't do a damned thing - I think it actually *added* to the
> > corruption, but I don't think any filesystem would have survived that)
>
> You might want to look at the modesetting-101 branch of DRM.  It's goal
> is similar to yours.  They even have a drm framebuffer.  I don't know
> how far they are with their goal, but I can see some progress.
>
> Here's their git tree:
>
> git://git.freedesktop.org/git/mesa/drm#modesetting-101

It sounds like we'll need a new KD_* flag for this work too, something like 
KD_TEXT_BUT_ONLY_ON_PANIC, sine with the above tree, the kernel will have 
intimite knowledge of the current graphics mode, framebuffer location, 
etc.  It should be enough to clear the scanout buffer and output the 
printk, though if there's a lot of rendering going on, the DRM driver 
might have to be pretty smart about it.

Jesse
