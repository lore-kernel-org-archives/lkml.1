Return-Path: <linux-kernel-owner+w=401wt.eu-S1763189AbXHKVPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763189AbXHKVPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 17:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXHKVPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 17:15:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:2780 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbXHKVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 17:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pFIfS0cNmRbFx5LzXHGtDLJj7Ku4DKOzqRq2cugV8a5pBaJ8/SGIjxou7UtC1yhWdoz7TZhqf4dqPg/ghlHV6Ivp3hGfxB54t2f53KtJs/ZIStHa+uoGOnkdRU2sfc+D0opJV5Bxm06vLz0DypnLJ5m7H86owFAJuw1Y5wCUKcA=
Message-ID: <d9b9d95f0708111415p5f39aa96q72f1d85a7b88a48b@mail.gmail.com>
Date: Sat, 11 Aug 2007 22:15:41 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708112302250.11054@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com>
	 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz>
	 <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com>
	 <Pine.LNX.4.64.0706201156410.23812@jikos.suse.cz>
	 <d9b9d95f0707201710g14d8a905s222c1209358f0196@mail.gmail.com>
	 <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz>
	 <Pine.LNX.4.64.0708101753410.11054@jikos.suse.cz>
	 <d9b9d95f0708111038p48f18660me02d3e75280b37e@mail.gmail.com>
	 <Pine.LNX.4.64.0708112302250.11054@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/07, Jiri Kosina <jkosina@suse.cz> wrote:
> Force feedback functionality shouldn't be influenced in any means by this
> patch - FF implementation doesn't care about the values of the
> input_dev->abs{max,min,fuzz,flat}.

So it means the patch should work for all other joysticks as well?
That's good news... ;)


> But it is questionable whether your joystick is fully compliant with PID
> protocol or it implements some sort of vendor-specific one.

I wouldn't be surprised if it's vendor-specific, as their original
driver doesn't work quite well, I had to download a patched driver
from their website. Also, they seem to work it around (as I did) with
the auto-calibration.

Thanks for the help!

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
