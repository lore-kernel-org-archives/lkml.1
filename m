Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYFXBpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYFXBpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYFXBpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:45:32 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:7965 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYFXBpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wy31g5ym8poSEUG7GJLNPg4No7Sl/XFl/G/ILgxFDkTe+/vfC/w3r6A7LZe0oUXIkl
         MA8WD/63+4EC+kBhyS8Q2LqPei8yjoAFteVfX1Tbbl/fcBKcvYGGj0G7rdx/hcMGnLGu
         qGtHz3n6Wm3xHm1De4kY0zmfxRFqlCTZVl/Tc=
Message-ID: <dd18b0c30806231845s1cc6151coc2a4f26ed3521500@mail.gmail.com>
Date: Tue, 24 Jun 2008 01:45:26 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Didier Raboud" <didier@raboud.com>
Subject: Re: stuck tcp connections 2.6.26-rc7
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <g3ol3u$li2$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806221109t2ff73f9ai52f6716748648a79@mail.gmail.com>
	 <20080622205927.301501e7.akpm@linux-foundation.org>
	 <dd18b0c30806230013x5446991bi9eba7623ffaae131@mail.gmail.com>
	 <g3ol3u$li2$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 5:04 PM, Didier Raboud <didier@raboud.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Justin Mattock wrote:
>
>> On Mon, Jun 23, 2008 at 3:59 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> On Sun, 22 Jun 2008 18:09:16 +0000 "Justin Mattock"
>>> <justinmattock@gmail.com> wrote:
>>>
>>>> Hello; I too am experiencing internet connectivity problems, for  a
>>>> while I thought
>>>> It was due to low bandwidth(or being ddos attacked) but yesterday I
>>>> noticed with watch netstat -ntu
>>>> send-Q was stuck on a number; the connection would not go to TIME_WAIT
>>>> resulting in music to pause, and t.v. to freeze.
>>>> In my experiences running xmms streaming music is fine, no problems,
>>>> but as soon as
>>>> you watch something with flash player the stream start's getting
>>>> really bad. In the past with older kernel's
>>>> I usually can watch t.v.(with flash) and stream music at the same time
>>>> without any trouble.
>>>> lately I've been Running the kernel in No forced Preemption with a
>>>> time frequency at 100. having the kernel set in this mode really shows
>>>> the connection problems, but if I change the preemption to another,
>>>> and bump up the timer frequency the poor internet connection is not as
>>>> bad(or stuck tcp) but still prevalent. more pops in the music, and
>>>> sudden internet loss for around five seconds, then goes back
>>>> So from over here streaming music has no problems from what I can see,
>>>> but as soon as I watch media, it becomes a mess.
>>>
>>> (cc netdev)
>>>
>>
>>
>> Cool, Thanks for sending the cc
>> regards;
>
> Hi,
>
> I get something like a similar bug: when pinging my local gateway, I loose
> packets (over wifi (iwl3945) ). Before the update to 2.6.26-rc7 (Debian), I
> had no such issues (which makes Internet browsing working but weirdly).
>
> I can't know for sure that my bug is related to the above, but suppose so.
> Please ask for details !
>
> Regards,
>
> Didier Raboud
> - --
> Swisslinux.org − Le carrefour GNU/Linux en Suisse −
> http://www.swisslinux.org
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAkhf17gACgkQwW1nnOmiePC/jQCcDxxCCFQbWV9swc0LY/o+/8o1
> gL4An225WZd8UquZMtRfYRklKi9kiOEI
> =hXPR
> -----END PGP SIGNATURE-----
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Cool;(cool as in I'm not the only one,not cool for sh*%y internet connections)
there is something definitely happening with the tcp connection.,
After looking more at the situation
I get a good connection when just streaming music, but as soon as I
watch with flash or even search through firefox
I'm getting a dead period of no internet, and then a few seconds later
no problems.Almost as if some timer in the code is missing something
or not firing off at the right time.
At this point I'm still uncertain with what is happening.
regards;

-- 
Justin P. Mattock
