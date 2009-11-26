Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbZKZIIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbZKZIIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbZKZIIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:08:05 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48361 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364AbZKZIID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:08:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q/h6uSJvRiE2AtHhOX1Qqtg2VJFHMaXTI/A1vgCOfGtQsQefH5cifk2IoKIpAM8Rqw
         fhMYklLqTq0+/96+GCRUboszh4kBzk4oobotZc5fv80DLVS8r6hwMQPAlDQOeS2+dIUj
         LIazO3zwqSKJ2z2PU2X6XNcEx5hU1SSSWtZMs=
Date: Thu, 26 Nov 2009 00:08:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: jarod@wilsonet.com, awalls@radix.net, j@jannau.net, jarod@redhat.com,
       khc@pm.waw.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126080804.GA28352@core.coreip.homeip.net>
References: <4BFB11CF-1835-4AFA-BDC6-F42288A9A6F4@wilsonet.com> <BDcbizrJjFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BDcbizrJjFB@christoph>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 09:01:00AM +0100, Christoph Bartelmus wrote:
> Hi,
> 
> on 25 Nov 09 at 12:44, Jarod Wilson wrote:
> [...]
> > Ah, but the approach I'd take to converting to in-kernel decoding[*] would
> > be this:
> [...]
> > [*] assuming, of course, that it was actually agreed upon that in-kernel
> > decoding was the right way, the only way, all others will be shot on sight.
> 
> I'm happy to see that the discussion is getting along.
> But I'm still a bit hesitant about the in-kernel decoding. Maybe it's just  
> because I'm not familiar at all with input layer toolset.
> 
> 1. For sure in-kernel decoding will require some assistance from userspace  
> to load the mapping from IR codes to keys. So, if there needs to be a tool  
> in userspace that does some kind of autodetection, why not have a tool  
> that does some autodetection and autoconfigures lircd for the current  
> device. Lots of code duplication in kernel saved. What's the actual  
> benefit of in-kernel decoding?

Why are you mixing configuration and decoding? Configuration I expect
will be done with the help of userspace. Udev is probably the best
place.

> 
> 2. What would be the format of the key map? lircd.conf files already exist  
> for a lot of remote controls. Will we have a second incompatible format to  
> map the keys in-kernel? Where are the tools that create the key maps for  
> new remotes?
> 

Same as the keymaps for the other input devices I'd expect.

> Maybe someone can shed some light on this.
> 
> Christoph

-- 
Dmitry
