Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZJNIAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZJNIAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbZJNIAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:00:03 -0400
Received: from mail-qy0-f186.google.com ([209.85.221.186]:38932 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbZJNIAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jd82qe8KbDqiTSO5RkOk27FAsK3e/EXzDGocjCUybNzuz03YIshu2bLWL/avvkrFZE
         V4pyft+yzcDD1r8Vr6Ho/Fge720M6ucqpaHURIRtPNZgphoxWxG3wv+lbudUuWlFHwrV
         ZG8p1gq4hTtdWs7gG6PWLZ8fwisaNB3qNH99k=
Date: Wed, 14 Oct 2009 00:59:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>,
       Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 1/6] Haptic: add haptic class
Message-ID: <20091014075919.GD5318@core.coreip.homeip.net>
References: <20091007061701.GA7567@july> <359ed6810910130335m45919d6ala921d4cbfa5a341a@mail.gmail.com> <5d5443650910130413t6ecd3d54p214d8f80972ed128@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650910130413t6ecd3d54p214d8f80972ed128@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:43:43PM +0530, Trilok Soni wrote:
> Hi Kyungmin, Dmitry,
> 
> On Tue, Oct 13, 2009 at 4:05 PM, Jani Nikula
> <ext-jani.1.nikula@nokia.com> wrote:
> > On Wed, Oct 7, 2009 at 09:17, Kyungmin Park <kyungmin.park@samsung.com> wrote:
> >> New haptic class support.
> >> This class handles the haptic devices.
> >
> > I'm wondering why a haptic class is needed when there is force
> > feedback support. Admittedly, I don't know the force feedback
> > implementation too well, but could someone please enlighten me on
> > this? Am I missing something here?
> >
> > I see haptics as simple force feedback, just with (usually) small
> > force and short duration. There are devices out there doing haptics
> > using vibra motors, which I think would be limited if implemented
> > using this haptics class driver. Would it be somehow problematic
> > interfacing with the simple haptic hardware using the force feedback
> > API?
> 
> Please share your inputs on ff_device usage instead of haptics class.
> I think Dmitry could add some points here as I don't see much users of
> ff_device and I don't see any embedded device (like mobile) using it.
> 

Using ff_device was considered when Jiri Slaby was trying to merge
PHANTOM driver, bit for that device FF infrastructure was too limited
and this it was decided that phantom would need a special userpsace that
knows what it is and how to handle it.

The curtrent haptic class seems to be bery limited and may be served via
FF (constant or other effect in a single direction) but I don't know
what kind of plans you have to extend it. I guess it warrants another
discussion.

-- 
Dmitry
