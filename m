Return-Path: <linux-kernel-owner+w=401wt.eu-S932660AbXHEC3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbXHEC3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 22:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXHEC3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 22:29:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:40055 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbXHEC3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 22:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kCHWQntJpSZKGfkhxEJN0IqvsYZRXhCwBpJKkhuEubDB+q0fvZRoSRas7tSPpQCoqj7yYnPJ48FbHvWiaX1txv82sckOXYcdD23PiHduI7/OM1t9uVW1mayuAxSeF/EYH4yWyCRz18j9ylJg6R4iBXYv7KJ/HvOD+TepVKfg1ys=
Message-ID: <b6a2187b0708041929x6afd8787t368d3f9f27b709c1@mail.gmail.com>
Date: Sun, 5 Aug 2007 10:29:14 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc2
Cc: lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
	 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
	 <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
	 <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Jeff - do I understand correctly that the "or" means that even *without* a
> suspend-to-ram sequence, and just by going into X and then going back to
> text-mode, the screen is corrupt?

I've done more tests. It seems that "suspend-to-ram" sequence is the
culprit. After resume, the text console is messed up. Not switching
X/console.

Boot up. Console -> X ok -> Console ok -> s2ram -> console bad -> X ok
-> console bad -> X ok.

> I just want to make sure that there is no suspend-related activity
> required for this at all, and the only common issue is probably just that
> suspend ends up *also* triggering the X mode-setting at resume..

It's suspend as indicated above.


> (Side note: if you have a modern distro, you might try to change the line
> that says
>         Driver "i810"
> in the /etc/X11/xorg.conf to say
>         Driver "intel"

I'll test this and get back.

Thanks,
Jeff.
