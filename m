Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZK1BfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZK1BfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 20:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZK1BfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 20:35:06 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:57877 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbZK1Beu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 20:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nQgMiBfhZkGZyJitCuL1Jy498rVxFLXvcTPMmkKOgC6UJzoRI2txbDBnJo/p+lYNq7
         IHv6t2SP8UzRcc6VNvbaEZcv2ELR8MFriw3tuc0Ui3+/VyJwq9zlMArNiPdcd267WFeS
         OVLCbUr6zRYMtzkgnb57gib9rT+3YvwMCxZoY=
Date: Fri, 27 Nov 2009 17:34:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Ferenc Wagner <wferi@niif.hu>, Christoph Bartelmus <lirc@bartelmus.de>,
       awalls@radix.net, christoph@bartelmus.de, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR system?
Message-ID: <20091128013443.GL6936@core.coreip.homeip.net>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com> <BDgcsm11qgB@lirc> <9e4733910911270949s3e8b5ba9qfe5025d490ad0cfa@mail.gmail.com> <874oof6b9u.fsf@tac.ki.iif.hu> <9e4733910911271121j452aa796j543f1fc3f6de7028@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910911271121j452aa796j543f1fc3f6de7028@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 02:21:13PM -0500, Jon Smirl wrote:
> On Fri, Nov 27, 2009 at 2:03 PM, Ferenc Wagner <wferi@niif.hu> wrote:
> > Admittedly, I don't know why /dev/mouse is evil, maybe I'd understand if
> 
> /dev/mouse is evil because it is possible to read partial mouse
> messages. evdev fixes things so that you only get complete messages.
> 

For me the main evil of /dev/mouse (and other multuiplexing interfaces)
is that it is impossible to remove one of the streams from the
multiplexed stream without affecting other users. And so are born
various "grab" schemes where we declare one application _the
application_ and let it "grab" the device.. which breaks when there are
other applications also interested in the same data stream.

-- 
Dmitry
