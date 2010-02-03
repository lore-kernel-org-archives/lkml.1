Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab0BCR3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:29:08 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:53146 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab0BCR3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:29:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hyEO90jElO58Vn2I2s7zDVRoV/yHI19RIJJKGFWvVeOFvgmau5lThMpFRu5B0sgzwr
         Bb4jN/6JoA7IWKoz5b1XbQVi81oHCrTC3gwQIZiXznjagRhQBGFQ0wgituNZduGMspG9
         bRSxM319MvB+OtboyTaS+eiNrtcVdJRNOWSps=
Date: Wed, 3 Feb 2010 09:28:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Childs <oblivian@users.sourceforge.net>
Cc: Ping Cheng <pingc@wacom.com>, Bastian Blank <waldi@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] Input: wacom - Convert remaining ids, part two
Message-ID: <20100203172846.GA30600@core.coreip.homeip.net>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org>
 <20100107182953.GA12985@wavehammer.waldi.eu.org>
 <6753EB6004AFF34FAA275742C104F952016A1329@wacom-nt10.wacom.com>
 <20100111222448.GA7959@wavehammer.waldi.eu.org>
 <20100203084725.GB22110@core.coreip.homeip.net>
 <bc07448c1002030634m2c8492a4h9dc1c1ad005bc98f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc07448c1002030634m2c8492a4h9dc1c1ad005bc98f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

On Wed, Feb 03, 2010 at 09:34:09AM -0500, Jason Childs wrote:
> Dmitry,
> 
> I actually responded on this issue to Ping last night.  My argument is that
> the usb_driver structure is subject to revision on a per kernel basis and
> should be in wacom_sys.c.

100% agree, and that is why usb_driver continues to stay in wacom_sys.
Wacom product IDs however are hardly linux-specific, usb_device_id is
unlikely to be changed significantly (since there are userspace ties)
and thus make sense to be kept in wacom_wac.c

>  Also with the new set of bamboo patches the
> features structures are copied per device instance during the initial probe
> so we are not breaking static conventions.

Ah, great. So nothing stops you guys from marking these statics const - I
can't do it till your changes reach me. Speaking of which, the next
merge window is getting close so now would be the best time to send your
pending queue towars me. *wink, wink*

Thanks.

-- 
Dmitry
