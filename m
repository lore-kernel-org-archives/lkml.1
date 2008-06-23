Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYFWRP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYFWRP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYFWRPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:15:16 -0400
Received: from main.gmane.org ([80.91.229.2]:59714 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756908AbYFWRPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:15:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Didier Raboud <didier@raboud.com>
Subject: Re: stuck tcp connections 2.6.26-rc7
Followup-To: gmane.linux.network
Date: Mon, 23 Jun 2008 19:04:56 +0200
Message-ID: <g3ol3u$li2$1@ger.gmane.org>
References: <dd18b0c30806221109t2ff73f9ai52f6716748648a79@mail.gmail.com> <20080622205927.301501e7.akpm@linux-foundation.org> <dd18b0c30806230013x5446991bi9eba7623ffaae131@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 154-100.5-85.cust.bluewin.ch
User-Agent: KNode/0.10.9
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Justin Mattock wrote:

> On Mon, Jun 23, 2008 at 3:59 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Sun, 22 Jun 2008 18:09:16 +0000 "Justin Mattock"
>> <justinmattock@gmail.com> wrote:
>>
>>> Hello; I too am experiencing internet connectivity problems, for  a
>>> while I thought
>>> It was due to low bandwidth(or being ddos attacked) but yesterday I
>>> noticed with watch netstat -ntu
>>> send-Q was stuck on a number; the connection would not go to TIME_WAIT
>>> resulting in music to pause, and t.v. to freeze.
>>> In my experiences running xmms streaming music is fine, no problems,
>>> but as soon as
>>> you watch something with flash player the stream start's getting
>>> really bad. In the past with older kernel's
>>> I usually can watch t.v.(with flash) and stream music at the same time
>>> without any trouble.
>>> lately I've been Running the kernel in No forced Preemption with a
>>> time frequency at 100. having the kernel set in this mode really shows
>>> the connection problems, but if I change the preemption to another,
>>> and bump up the timer frequency the poor internet connection is not as
>>> bad(or stuck tcp) but still prevalent. more pops in the music, and
>>> sudden internet loss for around five seconds, then goes back
>>> So from over here streaming music has no problems from what I can see,
>>> but as soon as I watch media, it becomes a mess.
>>
>> (cc netdev)
>>
> 
> 
> Cool, Thanks for sending the cc
> regards;

Hi,

I get something like a similar bug: when pinging my local gateway, I loose
packets (over wifi (iwl3945) ). Before the update to 2.6.26-rc7 (Debian), I
had no such issues (which makes Internet browsing working but weirdly).

I can't know for sure that my bug is related to the above, but suppose so.
Please ask for details !

Regards, 

Didier Raboud
- -- 
Swisslinux.org − Le carrefour GNU/Linux en Suisse −
http://www.swisslinux.org
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhf17gACgkQwW1nnOmiePC/jQCcDxxCCFQbWV9swc0LY/o+/8o1
gL4An225WZd8UquZMtRfYRklKi9kiOEI
=hXPR
-----END PGP SIGNATURE-----

