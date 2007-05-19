Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbXESIBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbXESIBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 04:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXESIBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 04:01:06 -0400
Received: from neopsis.com ([213.239.204.14]:49474 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754078AbXESIBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 04:01:05 -0400
Message-ID: <464EB44D.2040802@dbservice.com>
Date: Sat, 19 May 2007 10:24:45 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
References: <464C5FAC.8060609@dbservice.com> <75b66ecd0705181520p5c306e6dm146ccb4792853acd@mail.gmail.com> <Pine.LNX.4.64.0705190028100.27422@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705190028100.27422@twin.jikos.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.37,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 18 May 2007, Lee Revell wrote:
> 
>>> Despite it's a Microsoft product, it's actually very nice and useful. A
>>> little pad with a few buttons and connectors for a headset. It's an USB
>>> device, but it doesn't represent itself as an input/HID device:
>>>    HID device not claimed by input or hiddev
>> Is the audio part of the device USB audio class compliant?
> 
> Seems like the device is a bit strange - it in fact, as far as my 
> understanding goes (see the previous posts in this thread), doesn't have 
> any noticeable USB audio capabilities at all - it is just a HID device 
> with a few buttons (plus additional audio connector, which only "forwards" 
> the sound to a real audio device).

Exactly, it isn't a 'sound' device at all. It has a USB plug and plain
old headset/microphone cables which have to be put into the soundcard.
The pad itself has connectors for the headset/microphone, but those are
simply forwarded to the soundcard (there's the 'mute' button which can
be used to mute the microphone, and a volume wheel, but that's all it
can do with the sound).

> 
> So it's just a trivial HID device with probably a bit strange report 
> descriptor, it seems to me. It even has only one interface (the HID one).
> 

Someone at Microsoft probably thought, Hey, there's this
Telephony/Headset category, why not use that?

tom
