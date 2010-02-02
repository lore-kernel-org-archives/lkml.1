Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0BBIrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:47:11 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38761 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0BBIrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:47:06 -0500
Date: Tue, 2 Feb 2010 17:46:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [GIT PULL] sh updates for 2.6.33-rc7
Message-ID: <20100202084659.GC5716@linux-sh.org>
References: <20100202040628.GH13428@linux-sh.org> <fa686aa41002020017m5ea0020di6924905a631dc7d6@mail.gmail.com> <20100202082144.GB5716@linux-sh.org> <fa686aa41002020031r38e6bc9eyfce6476d86d47ec2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa41002020031r38e6bc9eyfce6476d86d47ec2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 01:31:18AM -0700, Grant Likely wrote:
> On Tue, Feb 2, 2010 at 1:21 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Tue, Feb 02, 2010 at 01:17:49AM -0700, Grant Likely wrote:
> >> Hold the phone; please coordinate with me before picking up SPI
> >> patches into your tree. ?I don't mind arch specific spi changes going
> >> in via a different tree, but I'd like to know about it before I waste
> >> time farting around with the same patch (like I did with this one
> >> tonight, and only found out that you also picked it up when I came
> >> across this pull request by chance).
> >>
> > If there's someone actively looking after the SPI stuff then that's fine.
> 
> I am now.  There wasn't anyone for a while.
> 
> > I didn't bother bouncing this one off of the SPI list since it's a
> > hardware-specific correctness fix and has no dependency on anything
> > subsystem related.
> 
> Fair enough, but the patch itself came across the SPI list, and so it
> showed up in the patchwork tracking of spi-devel-general which I'm
> using to keep on top of everything.  I brief reply to the patch email
> would have let me know that I didn't have to waste any time with it.
> 
Ahh.. this is where the confusion came from. The initial version of the
patch was only posted to the sh list, Magnus asked for it to be reposted
to the spi list and I hadn't heard anything about it since then, so I
assumed the poster just disappeared and I just cleaned it up and applied
it by hand. Apparently it was reposted but the sh list was dropped, so I
never saw the updated version. If I had known that it had hit the SPI
list I would have followed up there, I'll be more careful next time now
that I know someone is paying attention :-)
