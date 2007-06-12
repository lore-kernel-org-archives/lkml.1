Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbXFLVPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbXFLVPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXFLVPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:15:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:49509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbXFLVPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:15:22 -0400
Message-ID: <466F0CE4.4090507@anagramm.de>
Date: Tue, 12 Jun 2007 23:15:16 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "R.F. Burns" <burnsrf@gmail.com>
CC: Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: PC speaker
References: <a800cda90706120545w2c6d0bb0vb77bd4d961415c5c@mail.gmail.com>	 <75b66ecd0706120744g7cdb3392l6537b5c68c2d6b21@mail.gmail.com> <a800cda90706121325p18c85b00r7bc4b15b95517371@mail.gmail.com>
In-Reply-To: <a800cda90706121325p18c85b00r7bc4b15b95517371@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19oYOMw4LeAHUDTTAYL1Lm4vePe8QFX/U6Hp/I
 JmVmCkWnj/Ssapsl1u9qVSF8A8cnQUV+vszyKqfnS8q/sAbk0v
 AKoQLESJjhskLXzWMFtQA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

R.F. Burns schrieb:
> On 6/12/07, Lee Revell <rlrevell@joe-job.com> wrote:
>> On 6/12/07, R.F. Burns <burnsrf@gmail.com> wrote:
>> > Is it possible to write a kernel module which, when loaded, will 
>> blow the PC
>> > speaker?
>>
>> LOL.  May I ask what your use case is?
> 
> I am helping a small school system with a number of Linux
> workstations.  Previously, the students (middle and high schools)
> abused the sound cards in the systems.  This was remedied by changing
> the permissions on sound devices so that non-root users would be
> denied access (something easily done remotely, and on an automated
> basis.)
 > [...]

*smile*
What about denying students permissions to change all unwanted
<foo> on the system? They propably don't need to be root.

> At that point, the students started finding creative ways to abuse the
> PC speaker, which became rather distracting.  We unloaded and disabled
> the PC speaker kernel module, which remedied the situation for a
> while.

Disable kernel modules at all. Compile in what you need, and kick
out all unwanted stuff. Disable booting from anything else than
harddisk or network...

[OT on]

> So, the idea was raised about seeing if there was a way to blow the PC
> speaker by loading a kernel module.  If so, a mass-deployment of a
> kernel module overnight would take care of the PC speaker problem once
> and for all.

A speaker is basically an inductor. Together with the driving circuit,
it may form a resonant circuit. If you drive it exactly with the resonant
frequency[1], you might be able to overheat it. But take care, not to
burn your CPU too, when you reach microwave frequencies and get electromagnetic
waves reflected in the computer's case. Cross-check with Maxwell's
equations! ;-)

OTOH the students propably learn more in hacking a linux system than in any
other lesson. Tell them that the first one gets an A who can get real speech
output working on the PC speaker.

[1] http://en.wikipedia.org/wiki/Resonant_frequency

[OT off]

Good luck,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
