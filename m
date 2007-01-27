Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbXA0Sck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbXA0Sck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbXA0Sck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:32:40 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:49457 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbXA0Scj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:32:39 -0500
Date: Sat, 27 Jan 2007 19:32:19 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
In-Reply-To: <593246.19408.qm@web52505.mail.yahoo.com>
Message-ID: <Pine.LNX.4.61.0701271931260.22295@yvahk01.tjqt.qr>
References: <593246.19408.qm@web52505.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27 2007 10:31, Marc Perkel wrote:
>--- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>> 
>> >I'm a little stumped trying to set up raid 10. I
>> set
>> >it up and it worked but after a reboot it forgets
>> my
>> >raid setup.
>> 
>> Now, let's hear the name of the distribution you
>> use.
>> 
>> BTW, is md1 also disappearing?
>
>Sorry about that. I'm using Fedora Core 6. /dev/md0
>and /dev/md1, buth of which are raid 1 arrays survive
>the reboot. But when I make a raid 0 out of those two
>raid arrays that's what is vanishing.

That's interesting. I am using Aurora Corona, and all but md0 vanishes.
(Reason for that is that udev does not create the nodes md1-md31 on
boot, so mdadm cannot assemble the arrays.)


	-`J'
-- 
