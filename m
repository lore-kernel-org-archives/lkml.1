Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbZCXLUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbZCXLUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbZCXLUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:20:32 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:36269 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbZCXLUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:20:31 -0400
Message-ID: <49C8C1FB.2090608@monstr.eu>
Date: Tue, 24 Mar 2009 12:20:27 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 44/57] microblaze_v7: termbits.h termios.h
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <7342f6af4eb95f5bc2cd89a196ab33a3ddc4d5c1.1237407249.git.monstr@monstr.eu> <46a9b066a95fad763f6c12044dbc3cd580681fb9.1237407249.git.monstr@monstr.eu> <200903232037.23768.arnd@arndb.de>
In-Reply-To: <200903232037.23768.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 18 March 2009, monstr@monstr.eu wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  arch/microblaze/include/asm/termbits.h |  203 ++++++++++++++++++++++++++++++++
>>  arch/microblaze/include/asm/termios.h  |   88 ++++++++++++++
>>  2 files changed, 291 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/microblaze/include/asm/termbits.h
>>  create mode 100644 arch/microblaze/include/asm/termios.h
> 
> Did you take at the header files I have in git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/#generic-headers?


> I haven't gotten around to posting them for review, but I still think
> it would be great if we can at least make sure they are identical
> so we can remove your versions as soon as we have the asm-generic ones.

I tested it some min ago. I just take your termios.h and termbits.h from
asm-generic folder. I miss there only #include <asm/uaccess.h> in termion.h.

Compilation is OK and kernel works with your files too. For me is easy to use
your version. If they are there, I'll use them.

Thanks,
Michal


> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
