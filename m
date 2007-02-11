Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbXBKXic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbXBKXic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932920AbXBKXic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:38:32 -0500
Received: from 1wt.eu ([62.212.114.60]:2366 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919AbXBKXib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:38:31 -0500
Date: Mon, 12 Feb 2007 00:38:22 +0100
From: Willy Tarreau <w@1wt.eu>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211233822.GD13913@1wt.eu>
References: <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no> <fa.DhkemAgVI60diqZy0t9GzpwyLmk@ifi.uio.no> <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no> <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no> <fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no> <45CF60F2.5020308@shaw.ca> <20070211215211.GB13913@1wt.eu> <1171232786.4493.62.camel@nigel.suspend2.net> <20070211224637.GC13913@1wt.eu> <1171235922.4493.114.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171235922.4493.114.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 10:18:42AM +1100, Nigel Cunningham wrote:
[snip]
> > Hmm sorry, but we don't have the same usages of notebooks. For no reason
> > would I keep documents open, for two reasons :
> > 
> >   - when I shutdown my notebook, it is to move from one customer to
> >     home/company/another customer. There's no related work anyway, the
> >     network will have changed and I'll have to switch nearly all of my
> >     apps anyway. So using suspend just to save one reboot is not worth
> >     it (for me) IMHO.
> 
> The network configuration utilities can help there. In addition,
> Suspend2 preserves the commandline you used to boot with
> (/sys/power/suspend2/resume_commandline), so you can use a combination
> of slightly varying grub entries (I have one for not starting ath0 and
> one for starting it) and scripts to do different things in different
> environments. The resume_commandline is writable, so can be cleared
> after usage if there were anything sensitive there.

OK, I see there are features to make life easier when I decide to use
suspend. But it looks like that using suspend is the goal and dealing
with the constraints is a lot of work and I'm still far from being
convinced that it would provide me advantage.

> >   - I would certainly not keep open documents that are on crypted FS
> >     while I travel. Otherwise, it would be a total waste of time to
> >     enter my passphrase everytime I need to access them ! Some might
> >     argue that it would save me a lot of time, providing me with the
> >     ability to type my passphrase only once a month, but that's not
> >     what I'm looking for :-)
> 
> People are using Suspend2 with encryption today (I'm not sure about
> uswsusp). Some of them have set things up so you need to use a
> passphrase or usb key to resume, and the image itself is of course
> encrypted too.

Unless I'm mistaken, I have to type the passphrase twice then :
  - once at suspend
  - once at resume

which is once more per "boot" than what I'm doing on loop-aes.

> You could also close the document and not the app. Or both and just get
> the benefit of having the app in page cache post-resume.

I'm not much convinced by the advantage of reading 500 MB on disk to have
emacs in hot cache :-)

> > I can barely understand why one would prefer to suspend when the notebook
> > does not move at all, but under the conditions above, advantages are really
> > faint. I now realize that people I work with also face the same constraints,
> > which can explain why they don't use such features either, whatever the OS.
> 
> I guess the thing you're highlighting to me is the lack of awareness of
> the options that are available. Maybe I need to work harder at making
> people aware of the possible usage scenarios! :)

You're certainly right. I really think that this feature is clearly not for
me but it's more featureful than I initially thought, and I could encourage
some people to give it a try.

Best regards,
Willy

