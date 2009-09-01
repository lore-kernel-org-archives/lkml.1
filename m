Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZIANPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZIANPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZIANPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:15:42 -0400
Received: from rtr.ca ([76.10.145.34]:51705 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZIANPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:15:41 -0400
Message-ID: <4A9D1E7D.1050104@rtr.ca>
Date: Tue, 01 Sep 2009 09:15:41 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrei Tanas <andrei@tanas.ca>
Cc: Mark Lord <mlord@pobox.com>, Tejun Heo <tj@kernel.org>,
       Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: MD/RAID time out writing superblock
References: <004e01ca25e4$c11a54e0$434efea0$@ca> <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name> <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca> <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BC033.9000909@pobox.com> <4A9C60A1.50303@rtr.ca> <640f6103c45b6cba6f84f887bde227e4@localhost>
In-Reply-To: <640f6103c45b6cba6f84f887bde227e4@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrei Tanas wrote:
>>>>> The drive might take a longer time like this when doing error handling
>>>>> (sector remapping, etc), but then I would expect to see your remapped
>>>>> sector count grow.
>>>> Yes, this is a possibility and according to the spec, libata EH should
>>>> be retrying flushes a few times before giving up but I'm not sure
>>>> whether keeping retrying for several minutes is a good idea either.
>>>> Is it?
>>> ..
>>>
>>> Libata will retry only when the FLUSH returns an error,
>>> and the next FLUSH will continue after the point where
>>> the first attempt failed.
>>>
>>> But if the drive can still auto-relocate sectors, then the
>>> first FLUSH won't actually fail.. it will simply take longer
>>> than normal.
>>>
>>> A couple of those, and we're into the tens of seconds range
>>> for time.
>>>
>>> Still, it would be good to actually produce an error like that
>>> to examine under controlled circumstances.
>>>
>>> Hmm.. I had a drive here that gave symptoms like that.
>>> Eventually, I discovered that drive had run out of relocatable
>>> sectors, too.  Mmm.. I'll see if I can get it back (loaned it out)
>>> and perhaps we can recreate this specific scenario on it..
>> ..
>>
>> I checked today, and that drive is no longer available.
> 
> Mine errored out again with exactly the same symptoms, this time after only
> few days and with the "tunable" set to 2 sec. I got a warranty replacement
> but haven't shipped this one yet. Let me know if you want it.
..

Not me.  But perhaps Tejun ?
