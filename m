Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZDSWtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZDSWtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZDSWtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:49:33 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63031 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDSWtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=l3iipjrlcGr0kqvJKUjgn0LjxuWFiUVzbBE0SZgne+AONbf7OQZm1xyzXT+bs2iM2j
         /JQWiuhnk8xnWof+fepRBHO/xt6r82iXvavgVNrai+ex0wY8gHV4Zrlqlb+D8Zalg7FQ
         f5vjH5RqOuwho13KIe2BRm47T1JkNYkD1I9G8=
Message-ID: <49EBAA65.80701@gmail.com>
Date: Mon, 20 Apr 2009 00:49:09 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #13067] iwl3945: wlan0: beacon loss from AP - sending probe
 request
References: <crKhD-25m-3@gated-at.bofh.it> <crKhG-25m-5@gated-at.bofh.it> <crN5T-6s8-5@gated-at.bofh.it> <cs3u2-7kZ-13@gated-at.bofh.it>
In-Reply-To: <cs3u2-7kZ-13@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2009 11:10 PM, Rafael J. Wysocki wrote:
> On Friday 17 April 2009, Justin Madru wrote:
>> Rafael J. Wysocki wrote:
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.29.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13067
>>> Subject		: iwl3945: wlan0: beacon loss from AP - sending probe request
>>> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
>>> Date		: 2009-04-05 9:11 (12 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=123892272218266&w=4
>>>
>>>
>>>   
>> I'm getting this on .30rc2, so I confirm that it's still an issue (I'm 
>> not the original submitter).
>> It's really annoying because it's filling my logs like crazy. Below is 

Quite similar here, same kernel. I don't get this on 2.6.29 or 2.6.28:

[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

CPU0 attaching NULL sched-domain.

CPU1 attaching NULL sched-domain.

CPU0 attaching sched-domain:

 domain 0: span 0-1 level MC

  groups: 0 1

CPU1 attaching sched-domain:

 domain 0: span 0-1 level MC

  groups: 1 0

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request

wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: beacon loss from AP 00:1d:92:1d:1e:8e - sending probe request
wlan0: no probe response from AP 00:1d:92:1d:1e:8e - disassociating
wlan0: authenticate with AP 00:1d:92:1d:1e:8e
wlan0: authenticate with AP 00:1d:92:1d:1e:8e
wlan0: authenticated
wlan0: associate with AP 00:1d:92:1d:1e:8e
wlan0: RX ReassocResp from 00:1d:92:1d:1e:8e (capab=0x411 status=0 aid=1)
wlan0: associated

Regards,
Niel

