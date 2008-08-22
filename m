Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYHVTJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYHVTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYHVTJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:09:17 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:39670 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYHVTJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eCIHjwfYn47yunSuAZKwJ0a4qx1viFD/wkQ6Q7EEaqcfe6O9JkmvPxLkNNxQDYUiuL
         rlplXnk4P2S6HQpEeCm3Au0lUjEbySGvP+LDKKCfUnfTzYFJJ0FWDvLeci8e3R/zatoT
         Gg77TFTzdkPcd2NEj6+6UM8yRuNngXFvQUB9M=
Message-ID: <19f34abd0808221209jc3328e3xf20e7059f63917d3@mail.gmail.com>
Date: Fri, 22 Aug 2008 21:09:15 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080822085548.GA6542@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
	 <20080822085548.GA6542@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 10:55 AM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>
>> I just got this on v2.6.27-rc4 (+ unrelated fix):
>
> Did suspend ever work for you on this machine?

Yes, 2.6.20.9 works fine :-P

I am checking out your suggestions of IDE driver changes now.

(Next e-mail:)
>> I have no idea why this happens. Is it possible to trigger SysRq by
>> writing data on the other end of the serial console? (Maybe my cable
>> is bad or something, but data seems to be going in both directions
>> over my serial console.)
>
> Serial break translates to sysrq, IIRC.

Thanks, that's useful info.

I also figured out something else; apparently the ttys are set to
character echo mode in either or both directions. I guess this is why
I also get these "ttyS0: 3 input overrun(s)" messages all the time. Am
I the only one who experienced this? I'll experiment with stty.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
