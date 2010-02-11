Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab0BKU5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:57:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36936 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab0BKU5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:57:47 -0500
Date: Thu, 11 Feb 2010 21:57:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
Message-ID: <20100211205745.GA18202@basil.fritz.box>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org> <4B50C2FA.4020100@gmail.com> <4B50FC78.9010107@gmail.com> <20100122155237.e93a1c55.akpm@linux-foundation.org> <4B730EE3.4080405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B730EE3.4080405@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 08:54:11PM +0100, Jiri Slaby wrote:
> On 01/23/2010 12:52 AM, Andrew Morton wrote:
> > On Sat, 16 Jan 2010 00:38:32 +0100
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> >> (fixed subject)
> >>
> >> On 01/15/2010 08:33 PM, Jiri Slaby wrote:
> >>> On 01/13/2010 09:17 PM, akpm@linux-foundation.org wrote:
> >>>> The mm-of-the-moment snapshot 2010-01-13-12-17 has been uploaded to
> >>>
> >>> Hi, it crashes on my machine while booting up. It is a regression
> >>> against 2010-01-06-14-34. Doesn't it ring a bell by a chance?
> >>
> >> Well, memcpying to something like this:
> >> char *uevent_helper = CONFIG_UEVENT_HELPER_PATH;
> >> doesn't sound like a good idea :).
> >>
> >> And it's racy with sysctl path anyway.
> >>
> >> Looks like added by:
> >> sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
> 
> Ping Andi.

Sorry, busy with other stuff right now. There was at least one
other unsolved problem in this patch series. I'll try to look
at it on the weekend.

Andrew, it's ok for me if you just drop the series for now;
I'll resubmit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
