Return-Path: <linux-kernel-owner+w=401wt.eu-S1946499AbXBCQqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946499AbXBCQqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 11:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992430AbXBCQqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 11:46:24 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:40710 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946499AbXBCQqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 11:46:24 -0500
Message-ID: <45C4BC68.5090903@gmail.com>
Date: Sat, 03 Feb 2007 17:46:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Cyclades team <async@cyclades.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, nils@kernelconcepts.de, wim@iguana.be,
       R.E.Wolff@bitwizard.nl
Subject: Re: [PATCH 1/2] Char: add __devinitdata to pci_device_ids
References: <2106930977152662464@wsc.cz> <58cb370e0702030731i61b32e93j3f7a8f0e061cb136@mail.gmail.com> <4af2d03a0702030739n77afadf4t8d26d66416b075e1@mail.gmail.com> <20070203155044.GA32134@suse.de>
In-Reply-To: <20070203155044.GA32134@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH napsal(a):
> On Sat, Feb 03, 2007 at 04:39:34PM +0100, Jiri Slaby wrote:
>> On 2/3/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>>> On 2/3/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>> add __devinitdata to pci_device_ids
>>>>
>>>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>> http://lkml.org/lkml/2003/8/1/135
>>>
>>> I think that it is still true, Greg?
> 
> No it is not.
> 
>> Hmm, then I misunderstood this:
>> http://lkml.org/lkml/2007/1/17/136
>> ?
> 
> Yes, that is correct.
> 
> But Jiri, why do this?  What memory savings are you seeing here now that
> CONFIG_HOTPLUG is enabled by default?  The only people I see liking this
> kind of change are embedded, and I don't think many embedded devices
> have these drivers and do not use hotplug at the same time :)

Yes, correct, please cat this_patch >/dev/null.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
