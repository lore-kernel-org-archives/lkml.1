Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZGOP5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZGOP5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZGOP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:57:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:39554 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755548AbZGOP5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:57:48 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19z+N1UIUJziMwJ6TbBFX0zSRjodjq7iG/OfkF84P
	iPtsUSk6U3vS48
Message-ID: <4A5DFC79.6050804@fisher-privat.net>
Date: Wed, 15 Jul 2009 17:57:45 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: ykzhao <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH] Solve the issue with memory corruption on Intel BIOS.
References: <1247637314-5609-1-git-send-email-bug-track@fisher-privat.net> <20090715103431.4381b423@lxorguk.ukuu.org.uk>
In-Reply-To: <20090715103431.4381b423@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox schrieb:
> On Wed, 15 Jul 2009 07:55:14 +0200
> Alexey Fisher <bug-track@fisher-privat.net> wrote:
> 
>> In Bug 13710 was reported "corrupted low memory after resume on Intel
>> DG45ID board". It use AMI BIOS with Intel vendor string. We need to add this
>> vendor to CONFIG_X86_RESERVE_LOW_64K workaround.
> 
> Given that this is the first report of a problem with an Intel BIOS, and
> there are millions of systems not affected your match is far too wide I
> think. Match the board identifier as well at least rather than randomly
> making everyone suffer.

It did a memory dump on "windows vista sp2" before and after suspend.. 
there is the same corruption on same place. But it looks like windows do 
not use this part so intensive like linux do.

i send new patch to mailing list:
[PATCH] Lowmemory corruption. Quirk for Intel DG45ID board.
