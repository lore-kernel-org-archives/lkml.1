Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab0CEFSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 00:18:13 -0500
Received: from mail-iw0-f175.google.com ([209.85.223.175]:37817 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab0CEFSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 00:18:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=wlkyiZ0WZMlKpwgJrUFyWMDtyvUGS08Wh3e/+kKEvIZ+MKL9qtnJoizsh/iZ6T2aC1
         JE8XJhmovtr6KudZGFh68L7yR9pQUfbeQlnlTT8yeYduhpa0lD6agF7eOTnXuOlIKO0U
         SKKVNu29jVkV5Js0Klyttxm+sFJW15+LB4BqU=
MIME-Version: 1.0
In-Reply-To: <20100303151720.GA3191@thunk.org>
References: <20100303151720.GA3191@thunk.org>
Date: Fri, 5 Mar 2010 15:18:11 +1000
Message-ID: <21d7e9971003042118hf455ce5y7e839754d95440e@mail.gmail.com>
Subject: Re: [REGRESSION] X doesn't work with 2.6.33 (can't find any input 
	devices)
From: Dave Airlie <airlied@gmail.com>
To: tytso@mit.edu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 1:17 AM,  <tytso@mit.edu> wrote:
> After working around lvm breakage so I could at least boot 2.6.33, I'm
> now finding the next problem --- X doesn't work.  If I let X come up,
> it doesn't find any mouse or keyboard devices, so my machine becomes
> useless and I have to power cycle it unless I can log in remotely and
> reboot it.
>
> It worked just *fine* using 2.6.33-rc4.  I have no xorg.conf file (X
> is autoconfiguring itself) and I'm using an Ubuntu 9.10 userspace.
>
> I've enclosed the dmesg output (which shows the input devices
> correctly being detected by the kernel) and the Xorg.0.log file from
> the previous boot, where X does not come up.
>
> At this point, I'm not going to be able to dogfood test my ext4
> patches I plan to push to Linus, since 2.6.33 is completely useless to
> me.  Hopefully running the regression tests under KVM is going to have
> to be good enough.
>

Are you using 32 on 64 or anything like that?

15e184afa83a45cf8bafdb9dc906b97a8fbc974f is the only thing I can
see that might be close to changing something.

Dave.
