Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbXFJTCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbXFJTCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXFJTB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:01:57 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60969 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbXFJTB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:01:56 -0400
Message-ID: <466C49DB.6040409@gmail.com>
Date: Sun, 10 Jun 2007 20:58:35 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO translated
 into Japanese]
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <20070610175228.GA28947@uranus.ravnborg.org>
In-Reply-To: <20070610175228.GA28947@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2007 07:52 PM, Sam Ravnborg wrote:

> We once discussed about .po files for kconfig and back then
> the conclusion was not to keep them in the kernel tree.
> 
> I advocated that they should stay out back then.
> But on the other hand I do not see it causing much troubles
> having scripts/kconfig/po/da.po etc araound.
> 
> Any opinion about the .po files?

 From me, the same opinion as about any and all internationalized content in 
the tree -- please don't.

All that stuff only serves to multiply the speed at which a fixed percentage 
of content obsoletes itself. When it's still new and shiny, sure, stuff will 
get translated but in no time at all it'll become a fragmented mess which 
nobody ever feels right about removing because that would be anti-social to 
all those poor non-english speaking kernel hackers out there.

In current effect, English is the language of the linux kernel. Its messages 
are in English, most or all of the useful information available on it is in 
English, its developers communicate in (some semblance of) English...

More importantly even than any current practical situation though it seems 
this should also be how people should try to keep things. I'm not a native 
English speaker myself but English serves well as a common language among 
all us non-native speakers. I really do not so much want to have to learn 
more languages well enough to be able to understand technical discussions 
about operating system kernels in them still.

America is obviously historically (for a sufficiently short value of 
history) the main supplier/originator of computer software and as such, 
using English is often seen as something that needs to be fixed upon 
expansion but this is wrong. Please do not for a minute believe that 
internationalization is doing anyone a favour.

I know all about constantly translating computer terminology back and forth 
when a non-computer savvy friend asks something in the context of his/her 
Dutch language copy of Windows.

Internationalization is sometimes _neccessary_ (those same windows desktops) 
simply because the result needs to be used by people that you don't want to 
have to expect to be able to use English (because you'd limit your market) 
and things like adopting a character set that allows people to write down 
their names is obviously wonderful but generally internationalization only 
fragments.

RESIST! UNITE!

Rene.

