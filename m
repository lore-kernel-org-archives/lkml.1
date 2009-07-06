Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZGFIZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZGFIZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZGFIZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:25:00 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:42903 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbZGFIY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=S4a60MJw71xG0JdCXcfSd8BBiWJHSuZBzKV51jNdpKFa5r4LyfEUHtxY7ubOSQrygb
         kYUJJCgAAMWdgr2XCBf/HO5X5LvBnde0ZPyw/5QO+U40684I/peUOpkMSPMAW48mmuvW
         Taln+v0sHaE94a4HT+4rsww2tY/Vpl6o1toSg=
MIME-Version: 1.0
In-Reply-To: <4A51B204.4090501@petalogix.com>
References: <1245850289-6673-1-git-send-email-vapier@gentoo.org> 
	<200906241724.30947.arnd@arndb.de> <8bd0f97a0906241243k1d4a6d25x3216e940b356d2ca@mail.gmail.com> 
	<200906251255.06984.arnd@arndb.de> <4A51B204.4090501@petalogix.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 6 Jul 2009 04:24:42 -0400
Message-ID: <8bd0f97a0907060124t7a2641b8k8fe28f78f70fd3cf@mail.gmail.com>
Subject: Re: [PATCH] add checksum selftest
To: michal.simek@petalogix.com
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 6, 2009 at 04:12, Michal Simek wrote:
> Arnd Bergmann wrote:
>> On Wednesday 24 June 2009, Mike Frysinger wrote:
>>> ok, i can see that for the result, but how do i handle the functions
>>> that also take a __wsum ?  do i just always pass them 0 to avoid
>>> implementation issues ?
>>
>> No, any __wsum you pass in there should be fine, because that one
>> gets folded in in the end.
>
> Mike do you have any updated patch? I would like to check it on
> Microblaze too.

the latest code i have is here:
http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=shortlog;h=asm-generic

but i havent finished integrating the tests and i think they currently
fail on Blackfin due to it
-mike
