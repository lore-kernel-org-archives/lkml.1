Return-Path: <linux-kernel-owner+w=401wt.eu-S936720AbZLHRZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936720AbZLHRZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 12:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936708AbZLHRZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 12:25:44 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:42072 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936703AbZLHRZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 12:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E4aDXMomLIOBiQ6bgHNGgnGJbIqRwGs3UL8JvcSvDJxWR3BbpnQh+tZ1Kf0Jr5XjvW
         k0ascMvtSKpDNOfTaKLsJtWm+jkuLhl2jqfHjjgGk6c6JaxQdnOxBIKmXP1Sr71ey3Pk
         0pZ72icoVuP6squkH2uFUVZ5kMHO0gkmVdRZo=
Date: Tue, 8 Dec 2009 09:25:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Jon Smirl <jonsmirl@gmail.com>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091208172543.GA14271@core.coreip.homeip.net>
References: <1260070593.3236.6.camel@pc07.localdom.local> <20091206065512.GA14651@core.coreip.homeip.net> <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain> <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <m3skbn6dv1.fsf@intrepid.localdomain> <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com> <4B1D934E.7030103@redhat.com> <20091208042340.GC11147@core.coreip.homeip.net> <m38wddva9w.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m38wddva9w.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 02:57:15PM +0100, Krzysztof Halasa wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
> > Why woudl we want to do this? Quite often there is a need for "observer"
> > that maybe does not act on data but allows capturing it. Single-user
> > inetrfaces are PITA.
> 
> Lircd can work as a multiplexer. 

What this has to do with my statement? Did you mean retransmitter of sorts?

Also I may explicitely not want the data stream to be multiplexed...

> IMHO single-open lirc interface is ok,
> though we obviously need simultaneous operation of in-kernel decoders.

Why is the distinction?

-- 
Dmitry
