Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXGDTAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXGDTAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbXGDTAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:00:38 -0400
Received: from [84.243.56.243] ([84.243.56.243]:59268 "EHLO aurora.bayour.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758667AbXGDTAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:00:36 -0400
From: Turbo Fredriksson <turbo@bayour.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Forcibly remove broken disk from LV
Organization: Bah!
References: <87lkdwa4sb.fsf@pumba.bayour.com>
	<9a8748490707040313g4f89dfe2obf9ff73d5ef22307@mail.gmail.com>
	<9a8748490707040314l3166bdacy75c9394ca017c0ec@mail.gmail.com>
X-PGP-Fingerprint: B7 92 93 0E 06 94 D6 22  98 1F 0B 5B FE 33 A1 0B
X-PGP-Key-ID: 0x788CD1A9
X-URL: http://www.bayour.com/
Date: Wed, 04 Jul 2007 21:00:31 +0200
In-Reply-To: <9a8748490707040314l3166bdacy75c9394ca017c0ec@mail.gmail.com>
	(Jesper Juhl's message of "Wed, 4 Jul 2007 12:14:26 +0200")
Message-ID: <87ir90804w.fsf@pumba.bayour.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Jesper Juhl" <jesper.juhl@gmail.com>:

> On 04/07/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
>> On 04/07/07, Turbo Fredriksson <turbo@bayour.com> wrote:
>> > I have a disk that only gives SCSI errors etc which
>> > I want to remove from the VG. But vgreduce only hangs
>> > and so does pvremove...
>> >
>> > If I physically remove the disk, the vg/pv/lv etc isn't
>> > accessible so the vgreduce won't work (claims that it
>> > can't find any PV's etc).
>> >
>> > So how do I remove the disk?
>>
>> vgreduce --removemissing
>>
>> should do the trick I'd say.

Just hangs. I gues I must first cancel the pvmove...

> Ohh and by the way, pvremove also has a --force option - if needed.

Also just hangs...
