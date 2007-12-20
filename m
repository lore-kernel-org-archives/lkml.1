Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXLTFxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXLTFxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 00:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXLTFxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 00:53:33 -0500
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:60702 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbXLTFxc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 00:53:32 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Scott <linux-kernel@bluecamel.eml.cc>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Thu, 20 Dec 2007 06:53:28 +0100
User-Agent: KMail/1.9.7
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712200313.54425.volker.armin.hemmann@tu-clausthal.de> <1198122641.8341.1.camel@oasis.donpoo.home>
In-Reply-To: <1198122641.8341.1.camel@oasis.donpoo.home>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712200653.28996.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 20. Dezember 2007, you wrote:
> On Thu, 2007-12-20 at 03:13 +0100, Hemmann, Volker Armin wrote:
> > On Montag, 17. Dezember 2007, you wrote:
> >
> > and another one, this time tainted with the nvidia module:
> > 5194.130985] Unable to handle kernel paging request at 0000030000000000
> > RIP:
>
> This really sounds like bad hardware. Either memory or the mobo/riser
> card the memory is on. You might try lowering the memory timings of your
> memory in BIOS. Try removing 1/2 of your memory. If it still remove the
> other 1/2 and put the first 1/2 back and try again.

if this is bad hardware why:

- didn't this show up earlier?

- did a several hour memtest run couple of weeks ago didn't show up anything?

- and does stuff like compiling all of kde 3.5.8 or the latest kde4 rc finish 
without any problems?

If it would be bad hardware, I should see segfaults left and right, right? but 
I don't see them.  In fact, apart from the oopses the system works fine - 
even with the oopses the system works fine, apart from the occasional stuck 
ps aux

And this messages:
[41160.823959] kio_http_cache_[25229] general protection rip:32621f1fe9 
rsp:7fff59a3d270 error:0
show up on closing konqueror tabs/Konqueror. There are no surprising exits, no 
apps vanishing. 

But I will run memtest86+ (or should I use memtest86?).

Glück Auf,
Volker
