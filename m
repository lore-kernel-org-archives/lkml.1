Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbZKZQD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbZKZQD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZKZQDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:03:25 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:39695 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZKZQDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:03:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dAFzMKaVMx2Gvr8oemWZoHOTBc7JLYFoob8BlD9Rs2f5odThb/Bo8diSVNqz34+nKn
         q087bhD4fQmAFOzUDaV6UVHZsSBcEi3ElQ5grrns+kwT9SzEPKidx66XGxJlK7fPAHMf
         qsH0g+DIFpAoKCmB5cyxa5F18pGcvD312fT1s=
MIME-Version: 1.0
In-Reply-To: <9e4733910911260748v454d3b0bvcc6bfc86823cdd39@mail.gmail.com>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	 <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
	 <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
	 <4B0DA885.7010601@redhat.com> <4B0E9493.1090200@redhat.com>
	 <9e4733910911260748v454d3b0bvcc6bfc86823cdd39@mail.gmail.com>
Date: Thu, 26 Nov 2009 11:03:25 -0500
Message-ID: <9e4733910911260803q6f5cd6c0g5006e84f7733dc85@mail.gmail.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: 
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       Jarod Wilson <jarod@wilsonet.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
       dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, we used to have device specific user space interfaces for mouse
and keyboard. These caused all sort of problems. A lot of work went
into unifying them under evdev.  It will be years until the old,
messed up interfaces can be totally removed.

I'm not in favor of repeating the problems with a device specific user
space interface for IR. I believe all new input devices should
implement the evdev framework.

-- 
Jon Smirl
jonsmirl@gmail.com
