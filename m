Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbXIEQuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbXIEQuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXIEQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:50:08 -0400
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:4787 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbXIEQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:50:05 -0400
Message-ID: <46DEDE23.1090607@xs4all.nl>
Date: Wed, 05 Sep 2007 18:49:39 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       mpm@selenic.com, mb@bu3sch.de
Subject: Re: possible BUG while doing gpg --gen-key
References: <46CF079C.7010304@xs4all.nl>	<20070825011419.GL30705@stusta.de>	<46CFCA78.2090500@xs4all.nl>	<46D0272D.4010800@xs4all.nl>	<20070902045520.47b0eafe.akpm@linux-foundation.org> <20070905094023.3542dacc.akpm@linux-foundation.org>
In-Reply-To: <20070905094023.3542dacc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Sun, 2 Sep 2007 04:55:20 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Sat, 25 Aug 2007 14:57:17 +0200 Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>>> Udo van den Heuvel wrote:
>>>> Now it works:
>>> Stranger even:
>>>
>>> With audio-entropyd, rngd active and the netdev-random patch working I
>>> cannot reproduce the crash. Even after a fresh boot.
>> It would really help if your oops stack trace wasn't truncated.  Can you
>> see if you can generate a complete one using a recent kernel?  Enabling
>> CONFIG_FRAME_POINTER and disabling CONFIG_4K_STACKS might help in this.
>>
> 
> So... what's happening here?  Did the trail go cold?

Well, I just rebooted the box for an other problem (see
http://bugzilla.kernel.org/show_bug.cgi?id=8377 for details) and did a
fresh try:

 strace gpg --gen-key 2> ~/gpg.txt

Oddly enough the action completes successfully. This is with both
audio-entropyd and rngd running and netdev-random patch in the kernel.
The very same thing triggered the bug without problem before trying with
the mentioned deamons stopped.
Now even doing rm -rf .gnupg/ does not help in reproducing.

So yes, all is OK, and no, I don't know why.

