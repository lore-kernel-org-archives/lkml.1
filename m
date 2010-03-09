Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0CISQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:16:22 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:55141 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0CISQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:16:20 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B9690F8.1080804@cam.ac.uk>
Date: Tue, 09 Mar 2010 18:18:32 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
References: <20100301080342.GH765@core.coreip.homeip.net> <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com> 	<20100309175107.GB23378@core.coreip.homeip.net> <8bd0f97a1003090958i741f4ffm3528450e89089e9@mail.gmail.com>
In-Reply-To: <8bd0f97a1003090958i741f4ffm3528450e89089e9@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/10 17:58, Mike Frysinger wrote:
> On Tue, Mar 9, 2010 at 12:51, Dmitry Torokhov wrote:
>> On Tue, Mar 09, 2010 at 09:44:08AM -0500, Mike Frysinger wrote:
>>> On Mon, Mar 1, 2010 at 03:03, Dmitry Torokhov wrote:
>>>> Hi Linus,
>>>>
>>>> Please pull from:
>>>>
>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
>>>> or
>>>>        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
>>>>
>>>> to receive first round of updates for the input subsystem.
>>>
>>> i'm trying to figure out what the problem is with the ADXL34x and
>>> AD714x drivers you seem to have accepted (at least, you didnt say
>>> there was anything left for us to do).  i would have expected them to
>>> be in 2.6.33/2.6.34 already, but it seems they arent moving now.  so
>>> what's up ?
>>
>> I am still spooked by the fact that this is an accelerometer and does
>> not have to be an input device but maybe used for different purposes as
>> well.
> 
> the AD714x is not an accelerometer, it's a capacitance touch sensor
> 
> i understand the ADXL34x is a bit wonky, but what else would you
> propose ?  or just leave the driver in limbo forever until people
> forget about it ?
Hi Mike,

Perhaps whilst this remains in debate it might merge under misc, or
even staging temporarily.  That would avoid setting a precedent for
putting them in input.  I personally agree with Dmitry's wish to
avoid feature drift in input, but then we don't have anything else ready
for the big time.  Under staging the entire TODO list would be along
lines of awaiting a suitable framework...  This is effectively what
is going to happen to the various Ambient Light sensor drivers for
pretty much the same reason (see responses to our recent pull request).

We certainly want to be careful not to loose good drivers like this
and also to make them available to those who wish to use them.

Jonathan

