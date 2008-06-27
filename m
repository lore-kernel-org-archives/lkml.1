Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbYF0UAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbYF0UAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbYF0UAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:00:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:38713 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbYF0T77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=om5pFPDMa91eWA/htUwh1q4HtTZnLXQgVv7LjVkcM3FLUr7GqArNRbcib9r5nhKajB
         A7EJVzIoCGc7o81gcxFsafuvAqc08nDERH5Q+vuBFmjgqD5ERiUWdCuLmzU7XKv1wNMQ
         +xi6OIKbWhg9A4EIGIi6+nYpeILyT0OzCFFdA=
Message-ID: <19f34abd0806271259r338ec2c3w3b34e1703d4d97ba@mail.gmail.com>
Date: Fri, 27 Jun 2008 21:59:50 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: -tip build failure: No rule to make target `/etc/sound/dsp001.ld'
Cc: "Ingo Molnar" <mingo@elte.hu>, "Sam Ravnborg" <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080627194047.GD4306@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0806271225q409dfa51haca8de843eeec76f@mail.gmail.com>
	 <20080627194047.GD4306@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 9:40 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Fri, Jun 27, 2008 at 09:25:05PM +0200, Vegard Nossum wrote:
>> Hi,
>>
>> I was just building a randconfig in tip/master and hit this:
>>
>> make[2]: *** No rule to make target `/etc/sound/dsp001.ld', needed by
>> `sound/oss/pss_boot.h'.  Stop.
>>
>> It seems to be done like this on purpose, but it breaks randconfig
>> builds. Is this something that should be using firmware API?
>>
>> I'm attaching the config. Please forward this in the right direction,
>> if such a thing exists.
>
> It's your fault - compile errors with CONFIG_STANDALONE=n are expected.

Ah, I see. In that case, shouldn't 'make randconfig' also make sure
that this option is always =n? Or do I have to do

make randconfig
make CONFIG_STANDALONE=n

? Are there any other options which have similar effects (build-time
dependencies on the environment) and need to be overridden? Or maybe
we could have 'make randconfig' output a helpful explanation in case
this option gets set?

Thanks for helping out.

(Who said that kernel development was easy? ;-))


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
