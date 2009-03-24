Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZCXOof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZCXOof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZCXOoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:44:25 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51774 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZCXOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:44:24 -0400
Message-ID: <49C8F1C3.60807@monstr.eu>
Date: Tue, 24 Mar 2009 15:44:19 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Remis Lima Baima <remisbaima@gmail.com>
Subject: Re: [PATCH 44/57] microblaze_v7: termbits.h termios.h
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <200903232037.23768.arnd@arndb.de> <49C8C1FB.2090608@monstr.eu> <200903241457.29431.arnd@arndb.de>
In-Reply-To: <200903241457.29431.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 24 March 2009, Michal Simek wrote:
>>> I haven't gotten around to posting them for review, but I still think
>>> it would be great if we can at least make sure they are identical
>>> so we can remove your versions as soon as we have the asm-generic ones.
>> I tested it some min ago. I just take your termios.h and termbits.h from
>> asm-generic folder. I miss there only #include <asm/uaccess.h> in termion.h.
>>
>> Compilation is OK and kernel works with your files too. For me is easy to use
>> your version. If they are there, I'll use them.
> 
> Ok. I did not just mean these specific files, but all the headers in
> general. I assume that you have not had a chance to look into the
> other header files, which is ok. Remis is currently cleaning up bits
> of the generic header files in Linux based on my work, and I asked
> him to look into your tree to see how much can be shared.
> 
> Note that there is a problem of binary compatibility with certain headers.
> If e.g. the constants from termbits.h or some data structures slightly
> change, user space will still compile but no longer be compatible
> with other kernel versions, so this needs to be done very carefully.

As John wrote. It is completely new kernel and we do (will do) new toolchain
against new headers. I am open to use all generic approaches which will be in
kernel.

Thanks,
Michal

> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
