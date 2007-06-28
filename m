Return-Path: <linux-kernel-owner+w=401wt.eu-S1765518AbXF1TAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765518AbXF1TAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763995AbXF1TAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:00:30 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:35642 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764005AbXF1TA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:00:29 -0400
Message-ID: <4684046F.70205@gmail.com>
Date: Thu, 28 Jun 2007 20:56:47 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Anton Petrusevich <casus@casus.us>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706281442.05239.casus@casus.us> <4683CD9F.5030202@gmail.com> <200706281834.16564.casus@casus.us>
In-Reply-To: <200706281834.16564.casus@casus.us>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 06:34 PM, Anton Petrusevich wrote:

> Do you have an SPDIF out? If you don't then you don't need .asoundrc of 
> course.

I do on a number of cards, although being without sensible equipment (other 
than other soundcards) with an S/PDIF _in_ I don't actually use it for more 
than testing purposes.

Why do I need or want an .asoundrc? What's wrong with just using the iec958 
PCM device? Yes, I checked, and ICE1724 has it defined.

>> The first thing I don't know is why you need an .asoundrc at all. 
> 
> Because I want to route it differently, sometimes to spdif, sometimes to 
> headphones,

These two consist of specifying different devices (iec958 and <see below>)

> sometimes to mix sounds from different apps. Well, my config may be a bit
> ancient as it was written when dmix was not default.

Right, it now is. The "default" device on your card uses both the dmix and 
the dsnoop (for the capture direction) plugins and if you want direct access 
without going through those plugins, you can select the direct "hw" devices 
simply by specifying them.

> I have read some advices for ice1724 already. The main reason I wrote to
> lkml -- I hate .asounrc and reading docs about it. I hate "flexebility"
> that requires restarting apps after changing sound routes.

How would you _like_ things to work? asoundrc is a configuration file for 
alsa-lib. Would you perhaps suggest that alsa-lib expand its API with a 
snd_all_your_base_are_changed_out_from_under_you() application callback and 
sets notifies on its configuration file(s)? The application may have done 
things like enumerate the available PCM devices when it started up. Heck, 
maybe it's _busy_ playing through some "route" that you just changed...

>>> Is there a tool which can be used to configure .asoundrc?
>> vi.
> 
> I perfectly know this one. I would like to use some really user-friendly
> tool.

Some would say "emacs" now, but I'll not be as childish as that. I'm not 
like that. At all.

> I am not about ice1724 or .asounrc here. I am trying to talk about 
> user-friendliness of ALSA. It's very unfriendly.

In another recent post in this thread, I linked to:

http://forum.skype.com/lofiversion/index.php/t85880.html

Note how it starts with:

"Now that Skype uses ALSA for its sound I/O, I can set it up to work 
properly with my multi-channel audio interface (an Echo Gina24 with an 
8-channel ADAT interface chained onto it)."

That, as far as I'm concerned, says quite a bit. It says the flexibility is 
welcomed and used. Sure, simple things should be simple and with myself 
being a non-beginner-level user (user, not an audio professional) still not 
using or needing any configuration indicates to me that things have been 
partitioned correctly.

Yes, I can lose my way in the configuration as well when I play with it but 
I expect I could actually fairly easily remedy this by learning more about 
it before I start. And I expect for example that you hadn't heard of the 
iec958 PCM device before this message so that you only _think_ stuff is complex.

Generally, I tend to have some opinions on this blind insistance people seem 
to have they have an inalienable right to operate complex technology without 
turning their bloody brain on. I've been ranting just about enough now 
though so I'll not drag general "user friendliness" into it and just say 
that if I would have, it would've probably included the line "go buy a copy 
of windows and be gone" at some point.

Rene.

