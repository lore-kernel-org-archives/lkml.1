Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYG2Fls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYG2Fls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYG2Flj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:41:39 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:10351 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbYG2Fli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D4kj5wMqzfRXrUcj2IZyRdGB6QUKTnIfoVMSTceCJAWShJA5QfZ07ievuL7I00dJYc
         TnmPiW5gHeaBxUN37iTNDi2xYAKIBFYfQy83sXfm5KVtb8QLqjTC47gVxBPayrUZv5/r
         LTpp6Z6966cPe+ckxBChmPjdTvKOrTb7ijwY8=
Date: Tue, 29 Jul 2008 01:41:33 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net
Subject: Re: [PATCH] bcm5974-0.58: name changes, open/close and
	suspend/resume serialized
Message-ID: <20080729054132.GA5345@anvil.corenet.prv>
References: <4888311E.9010005@euromail.se> <20080725154250.GA1861@anvil.corenet.prv> <488A1A99.2070609@euromail.se> <20080725143015.ZZRA012@mailhub.coreip.homeip.net> <488AD712.1020102@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488AD712.1020102@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sat, Jul 26, 2008 at 09:49:38AM +0200, Henrik Rydberg wrote:
> Hi Dmitry,
> 
> one thing about the drivers/input/mouse/Kconfig patch:
> 
> The original version contained "select USB", which was later changed
> to "depends on USB" by Andrew Morton. I saw it reappear as "select USB"
> in your latest patch, and simply considered it a change back, but
> maybe it was an oversight?
> 

I am of the opinion that it is OK to "select" high-level subsystems that
don't have additional dependencies, especially if they are "past" the
original driver in menuconfig. I don't really like the idea of forcing
users revisiting earlier sub-menus after they selected a new subsystem
to see if there are any new options. Plus, if user wants driver for his
touchpad he does not really care whether it is PS/2 or USB, [s]he just
wants it to work.

So the change was intentional on my part.

-- 
Dmitry
