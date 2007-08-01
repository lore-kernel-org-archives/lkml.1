Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbXHAKP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbXHAKP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbXHAKPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:15:18 -0400
Received: from main.gmane.org ([80.91.229.2]:58192 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXHAKPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:15:16 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: Whats the problem with my IDE...
Date: Wed, 01 Aug 2007 12:19:52 +0200
Message-ID: <f8pmen$3vj$1@sea.gmane.org>
References: <f8mvg9$rc8$1@sea.gmane.org> <20070731104945.4411c85b@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pd9e43288.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.5) Gecko/20070723 SeaMonkey/1.1.3
In-Reply-To: <20070731104945.4411c85b@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At first: Thank you very much for the detailled information!

Alan Cox wrote:

> Bad CRC indicates a data transfer problem between the drive and the
> controller. The CRC is computed one end and verified the other. The OS
> isn't directly involved.
> 
> This usually means either
> #1 A 40 wire cable in use for > UDMA33

Not the case. Yesterday, I even replaced the 40 wire cable, in use for 
the DVD device, with a 80 wire one.

> #2 A drive plugged into the middle of the cable and none on the end

Yes, this was the case. I plugged the drive on the end now, but the 
drive, which was plugged into the middle of the cable, wasn't the one, 
which errors, it was the DVD device (hdc).

> #3 The short part of the cable connected between a drive and the
> controller not the long part

Not the case.

> And occassionally it may indicate power, iffy connectors or electrical
> noise problems.

... don't know about how to find and remove such problems...

I still have those messages, but now there seem to be much less of them.

It would really help me, if someone could tell me about how critical 
such error messages are.

Is this a common problem of IDE connections? May I just ignore those 
messages, if I tried anything to get rid of them, or do they tell me 
"get a new hardware, the old one will fail, soon"? Will my data be 
read/written without mistakes, even with those errors?

Its interesting, that I only get those messages using the Slackware 
install CD, which has many kernel modules built into the kernel.

With the "slimmed down" kernel of slackware, which even needs an initrd 
for ext2 root devices, I don't get this errors, so currently I only get 
them while installing and not while my daily work on my system...

Maybe I'll install the "huge" kernel, with the many "built in" stuff, 
onto my regular Slackware install, tomorrow, to see if this will cause 
those errors.

Thank you *very* much for any help and information!

Yours

Manuel

