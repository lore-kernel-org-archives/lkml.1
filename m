Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZLCWMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZLCWMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZLCWMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:12:35 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:36638 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZLCWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:12:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h1SqQInSuQ+8cE68fWTw2tChawwz6O8oeUEk2BmmTCMWMj01jUNevHSZo1BNIZZdu/
         gncxfn9aITB5FwG17c0o/J8lUdJt+mrRghFnVw3InEo3onV080to/mD3FzuWCPvrQkjx
         xho8Uk9efJxXXNzHZYQ17WA4//bv+XBy6DvMA=
Date: Thu, 3 Dec 2009 14:12:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: mchehab@redhat.com, awalls@radix.net, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, jonsmirl@gmail.com, khc@pm.waw.pl,
       kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091203221231.GE776@core.coreip.homeip.net>
References: <4B18292C.6070303@redhat.com> <BEBfoS11qgB@lirc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BEBfoS11qgB@lirc>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 10:51:00PM +0100, Christoph Bartelmus wrote:
> Hi Mauro,
> 
> on 03 Dec 09 at 19:10, Mauro Carvalho Chehab wrote:
> [...]
> >>> So the lirc_imon I submitted supports all device types, with the
> >>> onboard decode devices defaulting to operating as pure input devices,
> >>> but an option to pass hex values out via the lirc interface (which is
> >>> how they've historically been used -- the pure input stuff I hacked
> >>> together just a few weeks ago), to prevent functional setups from
> >>> being broken for those who prefer the lirc way.
> >>
> >> Hmm.  I'd tend to limit the lirc interface to the 'raw samples' case.
> 
> >> Historically it has also been used to pass decoded data (i.e. rc5) from
> >> devices with onboard decoding, but for that in-kernel mapping + input
> >> layer really fits better.
> 
> > I agree.
> 
> Consider passing the decoded data through lirc_dev.
> - there's a large user base already that uses this mode through lirc and  
> would be forced to switch to input layer if it disappears.

I believe it was agreed that lirc-dev should be used mainly for decoding
protocols that are more conveniently decoded in userspace and the
results would be looped back into input layer through evdev which will
be the main interface for consumer applications to use.

-- 
Dmitry
