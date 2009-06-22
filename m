Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZFVJdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZFVJdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZFVJdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:33:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:56290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZFVJda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:33:30 -0400
Date: Mon, 22 Jun 2009 11:33:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Pavel Machek <pavel@ucw.cz>
Cc: David Miller <davem@davemloft.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, swetland@google.com, arve@android.com,
       linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: defkeymap making machine useless (was Re: HTC Dream aka. t-mobile
 g1 support)
In-Reply-To: <20090618230704.GB8529@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.0906221131380.7457@wotan.suse.de>
References: <d6200be20906171436y5280ed8do561d2d53d73ca78@mail.gmail.com> <20090618101309.GC28892@elf.ucw.cz> <a55d774e0906181233p35b60cd2ga401bd1304267643@mail.gmail.com> <20090618.123845.232783995.davem@davemloft.net> <20090618230704.GB8529@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Pavel Machek wrote:

> > > Yeah, I wasn't sure how to handle this.  We try to keep the 
> > > msm/dream stuff in a state that doesn't break other parts of the 
> > > tree, but there doesn't seem to be support for different keymaps for 
> > > different devices.
> > How it's supposed to work is that you have a specific keyboard driver 
> > and that emits PC keyboard codes into the core kernel using a 
> > translation table in your driver.
> Of course, Dream does  that.  But that's not _nearly_ enough. Dream
> lacks keys such as: esc, arrows, symbols (/;'[]\-=). That means that
> for +, you can't press shift-=, you need to press altgr-P.

I don't seem to have enough context, but wouldn't writing a separate serio 
driver, which would do all the needed translations be enough here?

-- 
Jiri Kosina
SUSE Labs
