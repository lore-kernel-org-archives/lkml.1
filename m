Return-Path: <linux-kernel-owner+w=401wt.eu-S1764983AbXLNKSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764983AbXLNKSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbXLNKS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:18:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:59762 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbXLNKS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:18:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BnBqKqMfUVSvkPnu6iGRuqSBSXoW+fmA97tfGt8mdx20h8jwteZFleLiRmWyQ3z+rLS13N9LQAKAQzG/vrSMlh+Ylh85tIn+5wgU3sAEb5BHj25W7YtqfVTA+V+OZ2XMte7McCwrT67CBTrcBy74c9a28kskXkTCEw7Ql+ejSoo=
Message-ID: <4762586F.8090603@gmail.com>
Date: Fri, 14 Dec 2007 11:18:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arun Thomas <arun.thomas@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>	 <20071214015315.09829a99.akpm@linux-foundation.org> <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com>
In-Reply-To: <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2007 11:01 AM, Arun Thomas wrote:
> On Dec 14, 2007 4:53 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Fri, 14 Dec 2007 04:10:31 -0500 "Arun Thomas" <arun.thomas@gmail.com> wrote:
>>

some time before:
[   20.101392] Calibrating delay using timer specific routine..
5989.01 BogoMIPS (lpj=11978034)

>>> [   20.185881] Initializing CPU#1
>>> [  527.926587] Calibrating delay using timer specific routine..
>>> 200566.59 BogoMIPS (lpj=401133185)
>> Silly question: is that delay actually observeable by a human,
>> or is it just a leap in the printk timestamping?
> 
> Good question. Yes, it's human-observable. The kernel "hangs" for  8
> mins by my wall clock, and then it continues to boot up.

By the way, the same processor here, but
Calibrating delay using timer specific routine.. 5984.76 BogoMIPS (lpj=11969527)
for the second core.

The calibration is some kind of weird there.

If any info needed from me, feel free to ask (x86_64 here). No problems with it
here AFAIK.
