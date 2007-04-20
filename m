Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbXDTUru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbXDTUru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbXDTUru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:47:50 -0400
Received: from styx.suse.cz ([82.119.242.94]:51413 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754507AbXDTUrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:47:47 -0400
Date: Fri, 20 Apr 2007 22:47:24 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, edouard.tisserant@wanadoo.fr
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
Message-ID: <20070420204724.GB5334@suse.cz>
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com> <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz> <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com> <Pine.LNX.4.64.0704201533300.5138@jikos.suse.cz> <cb7bb73a0704200855xe841ecdoc9a0f67fc6f7009e@mail.gmail.com> <d120d5000704200901m44c9a3aei9ee0572c3b0a61ab@mail.gmail.com> <cb7bb73a0704200909h2f47e04cq87cb3dd91d7144f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb7bb73a0704200909h2f47e04cq87cb3dd91d7144f7@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 06:09:55PM +0200, Giuseppe Bilotta wrote:
> On 4/20/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> >On 4/20/07, Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
> >>
> >> Sorry, it seems I was wrong, it's not usbhid but usbmouse taking over.
> >> After a fresh plug (e.g. at bootup) I get the following:
> >>
> >
> >Well, the question is - why do you have usbmouse module on your system?
> 
> Stock Debian kernel 2.6.18 comes with it.
> 
> With my custom kernels I can probably skip compiling it at all, if you
> so suggest; should I blacklist it for the distro kernel? Or is there a
> chance that some random USB mouse plugged in would fail to function by
> doing so?
 
usbmouse and usbkbd are only intended for embedded systems where the
full usbhid doesn't fit and for testing purposes: Normal distros
shouldn't have them enabled.

-- 
Vojtech Pavlik
Director SuSE Labs
