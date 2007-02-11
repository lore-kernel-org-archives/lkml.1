Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbXBKXpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbXBKXpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932925AbXBKXpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:45:12 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:53110 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbXBKXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:45:10 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Willy Tarreau <w@1wt.eu>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070211233822.GD13913@1wt.eu>
References: <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	 <fa.DhkemAgVI60diqZy0t9GzpwyLmk@ifi.uio.no>
	 <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no>
	 <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no>
	 <fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no> <45CF60F2.5020308@shaw.ca>
	 <20070211215211.GB13913@1wt.eu>
	 <1171232786.4493.62.camel@nigel.suspend2.net>
	 <20070211224637.GC13913@1wt.eu>
	 <1171235922.4493.114.camel@nigel.suspend2.net>
	 <20070211233822.GD13913@1wt.eu>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 10:45:09 +1100
Message-Id: <1171237509.4493.145.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 00:38 +0100, Willy Tarreau wrote:
> On Mon, Feb 12, 2007 at 10:18:42AM +1100, Nigel Cunningham wrote:
> [snip]
> > > Hmm sorry, but we don't have the same usages of notebooks. For no reason
> > > would I keep documents open, for two reasons :
> > > 
> > >   - when I shutdown my notebook, it is to move from one customer to
> > >     home/company/another customer. There's no related work anyway, the
> > >     network will have changed and I'll have to switch nearly all of my
> > >     apps anyway. So using suspend just to save one reboot is not worth
> > >     it (for me) IMHO.
> > 
> > The network configuration utilities can help there. In addition,
> > Suspend2 preserves the commandline you used to boot with
> > (/sys/power/suspend2/resume_commandline), so you can use a combination
> > of slightly varying grub entries (I have one for not starting ath0 and
> > one for starting it) and scripts to do different things in different
> > environments. The resume_commandline is writable, so can be cleared
> > after usage if there were anything sensitive there.
> 
> OK, I see there are features to make life easier when I decide to use
> suspend. But it looks like that using suspend is the goal and dealing
> with the constraints is a lot of work and I'm still far from being
> convinced that it would provide me advantage.

Ok. I don't feel like I have to convince everyone :)

> > >   - I would certainly not keep open documents that are on crypted FS
> > >     while I travel. Otherwise, it would be a total waste of time to
> > >     enter my passphrase everytime I need to access them ! Some might
> > >     argue that it would save me a lot of time, providing me with the
> > >     ability to type my passphrase only once a month, but that's not
> > >     what I'm looking for :-)
> > 
> > People are using Suspend2 with encryption today (I'm not sure about
> > uswsusp). Some of them have set things up so you need to use a
> > passphrase or usb key to resume, and the image itself is of course
> > encrypted too.
> 
> Unless I'm mistaken, I have to type the passphrase twice then :
>   - once at suspend
>   - once at resume
> 
> which is once more per "boot" than what I'm doing on loop-aes.

I'm not sure. I don't use encryption myself, so I don't understand all
the fine details. I just know that there are people out there using
encryption, loop-aes, dmsetup and all that sort of stuff. I don't have
to worry about it because they use an initrd/ramfs to do whatever they
need to do to provide access to the device on which the image is found,
then

echo /dev/whatever_funny_device > /sys/power/suspend2/resume2
echo > /sys/power/suspend2/do_resume

> > You could also close the document and not the app. Or both and just get
> > the benefit of having the app in page cache post-resume.
> 
> I'm not much convinced by the advantage of reading 500 MB on disk to have
> emacs in hot cache :-)

Neither am I! Presumably you'd have a lot more than emacs in there
though :) You could always switch to vim! (*ducks*)

Regards,

Nigel

