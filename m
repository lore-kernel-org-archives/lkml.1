Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYHMPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYHMPYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbYHMPYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:24:39 -0400
Received: from barnes.cubic.ch ([78.46.44.112]:35901 "EHLO barnes.cubic.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbYHMPYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:24:38 -0400
Message-ID: <48A2FCA2.4040603@cubic.ch>
Date: Wed, 13 Aug 2008 17:24:18 +0200
From: Tim Tassonis <timtas@cubic.ch>
Reply-To: timtas@cubic.ch
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ryan Hope <rmh3093@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Krufky <mkrufky@linuxtv.org>,
       Adrian Bunk <bunk@kernel.org>, Pavel Machek <pavel@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: reiser4 for 2.6.27-rc1
References: <4896F56D.7080503@cubic.ch> <20080813125807.GC6995@ucw.cz>	 <20080813131839.GB26351@cs181140183.pp.htv.fi>	 <37219a840808130624p3d4dca0bja2935d6f34beaf7e@mail.gmail.com>	 <48A2E391.3080404@cubic.ch>	 <20080813143613.61101a5e@lxorguk.ukuu.org.uk>	 <48A2E8EA.2060704@cubic.ch> <48f7fe350808130759w18b887dcr1978ccf1c49d1c75@mail.gmail.com>
In-Reply-To: <48f7fe350808130759w18b887dcr1978ccf1c49d1c75@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.9 (--)
X-Spam-Report: Spam detection software, running on the system "barnes.cubic.ch", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Ryan Hope wrote: > On Wed, Aug 13, 2008 at 10:00 AM, Tim Tassonis
	<timtas@cubic.ch> wrote: >> I am in favour of renaming reiser4 exactly because
	it is not yet in and >> naming a filesystem after its author is not as automatic
	as putting the name >> of the singer on a record sleeve. > > There is no
	point in renaming the filesystem, its already known as > reiser4, it should
	stay that way. [...] 
	Content analysis details:   (-2.9 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	1.5 DNS_FROM_RFC_BOGUSMX   RBL: Envelope sender in bogusmx.rfc-ignorant.org
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Hope wrote:
> On Wed, Aug 13, 2008 at 10:00 AM, Tim Tassonis <timtas@cubic.ch> wrote:
>> I am in favour of renaming reiser4 exactly because it is not yet in and
>> naming a filesystem after its author is not as automatic as putting the name
>> of the singer on a record sleeve.
> 
> There is no point in renaming the filesystem, its already known as
> reiser4, it should stay that way.

One last (batch of) comment(s):

I am not advocating renaming the existing -mm implementation to 
something else so it can rot there under a different name.

I can very well live with reiser4 not making it into mainline, I never 
used reiser3 (only once for two, and after a power outage rendered the 
fs unusable and fsck did fsck all, I chose reliability over 
"performance") and am quite happy with ext3 for years and btrfs looks 
promising, too.

I was merely thinking: If reiser4 really is all that great and some 
people want it desperately in mainline, apart from fixing outstanding 
issues or convincing Al etc there are none left, they might rename it to 
reduce the controversy potential over its inclusion. I would think that 
for people desperately wanting it in, the features of reiser4 are more 
important than the name and the name is probably somewhat "difficult".

Renaming something for political reasons is certainly something you 
shouldn't do aggressively, but I would favour it in this case:
- For mainline, it's no rename, as it is not in yet.
- I don't like having the author's name as the fs's name anyway.
- It might save some unnecessary bad press .

On the other hand, I guess the real victims probably don't care and so 
it wouldn't bother me that much either.

Tim

