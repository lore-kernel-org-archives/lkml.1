Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXERWat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXERWat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXERWam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:30:42 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36578 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbXERWam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:30:42 -0400
Date: Sat, 19 May 2007 00:30:34 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Lee Revell <rlrevell@joe-job.com>
cc: Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
In-Reply-To: <75b66ecd0705181520p5c306e6dm146ccb4792853acd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705190028100.27422@twin.jikos.cz>
References: <464C5FAC.8060609@dbservice.com>
 <75b66ecd0705181520p5c306e6dm146ccb4792853acd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Lee Revell wrote:

> > Despite it's a Microsoft product, it's actually very nice and useful. A
> > little pad with a few buttons and connectors for a headset. It's an USB
> > device, but it doesn't represent itself as an input/HID device:
> >    HID device not claimed by input or hiddev
> Is the audio part of the device USB audio class compliant?

Seems like the device is a bit strange - it in fact, as far as my 
understanding goes (see the previous posts in this thread), doesn't have 
any noticeable USB audio capabilities at all - it is just a HID device 
with a few buttons (plus additional audio connector, which only "forwards" 
the sound to a real audio device).

So it's just a trivial HID device with probably a bit strange report 
descriptor, it seems to me. It even has only one interface (the HID one).

-- 
Jiri Kosina
