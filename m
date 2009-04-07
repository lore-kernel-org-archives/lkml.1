Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbZDGQFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbZDGQFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759542AbZDGQFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:05:19 -0400
Received: from outbound-mail-318.bluehost.com ([67.222.54.250]:35399 "HELO
	outbound-mail-318.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759296AbZDGQFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:05:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SnbDEoDuT5pD5d3Frtc+IM3Q1wgjeLQ32+uCcZPBb/udfbP/qgqjSj3Z3GiPaTol4HWzRLPcAL1nceZqxskUVuUrr+tctk2Zf3/ZmmT6VDSOSZbV9Xk//xx6ultSSOJe;
Date: Tue, 7 Apr 2009 09:04:29 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20090407090429.6d29a23e@hobbes>
In-Reply-To: <20090406.210426.38766000.davem@davemloft.net>
References: <20090406.190745.263215778.davem@davemloft.net>
	<alpine.LFD.2.00.0904061931160.4010@localhost.localdomain>
	<20090406202441.1c050ec6@hobbes>
	<20090406.210426.38766000.davem@davemloft.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Apr 2009 21:04:26 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date: Mon, 6 Apr 2009 20:24:41 -0700
> 
> > On Mon, 6 Apr 2009 19:32:11 -0700 (PDT)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >> On Mon, 6 Apr 2009, David Miller wrote:
> >> 
> >> > From: Linus Torvalds <torvalds@linux-foundation.org>
> >> > Date: Mon, 6 Apr 2009 18:25:31 -0700 (PDT)
> >> > > 
> >> > > 
> >> > > The sky2 driver is buggered (by the previous pull, I presume).
> >> > > Some PCI interaction. NULL pointer dereference at boot.
> >> > 
> >> > Fixed in the PCI tree, have you pulled that one yet?
> >> 
> >> Nobody has even _asked_ me to pull.
> >> 
> >> What's the point of having fixes available if they aren't merged?
> > 
> > I just pushed it into my repo today and wanted at least a day of
> > linux-next before asking you to pull.
> 
> I feel like I've been watching people get pointed to that fix
> for what seems like days.
> 
> In fact this is why I was under the impression that you had
> already asked Linus to merge the fix. :-)

It came in right as I was putting together my tree for the merge
window; putting it in along with a few other fixes would have meant a
delay to do more testing etc so I figured I'd put it off until now.
Sorry about that; I didn't know so many people were running into it.

-- 
Jesse Barnes, Intel Open Source Technology Center
