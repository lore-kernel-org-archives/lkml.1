Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZKISHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZKISHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZKISHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:07:18 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:35104 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZKISHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:07:17 -0500
Date: Mon, 9 Nov 2009 19:07:17 +0100
From: Daniel Mack <daniel@caiaq.de>
To: David Newall <davidn@davidnewall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-ID: <20091109180717.GD14091@buzzloop.caiaq.de>
References: <4AF7D439.4030305@ladisch.de>
 <20091109091044.GX29442@buzzloop.caiaq.de>
 <4AF7DDC1.4090006@ladisch.de>
 <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
 <4AF7FC64.6030904@ladisch.de>
 <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
 <20091109145056.GB14091@buzzloop.caiaq.de>
 <4AF8582B.2000403@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF8582B.2000403@davidnewall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 04:28:03AM +1030, David Newall wrote:
> Daniel Mack wrote:
> > I had that previously and the response was that there is no reason to
> > define that setting per-boot process, as it is rather unlikely that you
> > want to change it from one boot to the next. Hence, it should be set at
> > compile time.
> >   
> 
> It should be set as a boot parameter, since this is fixed at system
> installation and then left untouched.

I'd be fine with either way. As long as it disables the blinking cursor.

> It seems like adding cruft to the kernel that is just as effectively
> available at run-time. Where does it end? Do we eventually add bash to
> the kernel?

Well, all I need is a way to disable the cursor at boot time, as we
don't want it to be in our boot screen on a embedded system. It is not
only ruin the aesthetics but also gives the wrong assumption that the
system awaits input. There is no userspace at this point, so that's no
option.

My first approach was adding a __setup variable to select that, but it
wasn't beloved by the people get_maintainer.pl spit out. So I made it
compile-time definable, and Clemens extended that to a more powerful
interface of settings.

I don't really have a strong opinion on which way to go, all I need is a
cursor-free system startup :) And I would of course prefer that patch to
be in mainline.

Daniel

