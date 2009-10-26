Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZJZQBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZJZQBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZJZQBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:01:04 -0400
Received: from relay2.mail.masterhost.ru ([83.222.23.62]:50193 "EHLO
	relay2.mail.masterhost.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZJZQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:01:04 -0400
Message-ID: <4AE5C7C0.3060305@mayc.ru>
Date: Mon, 26 Oct 2009 19:01:04 +0300
From: "Anton D. Kachalov" <mouse@mayc.ru>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rayson Ho <raysonlogin@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: FatELF & patents
References: <73a01bf20910260850v215385e6q2cbbf9133acd5e1e@mail.gmail.com>
In-Reply-To: <73a01bf20910260850v215385e6q2cbbf9133acd5e1e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SpamTest-Envelope-From: mouse@mayc.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 10411 [Oct 26 2009]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rayson Ho wrote:
> Just a heads up...
>
> Apple (NeXT) patented the technologies behind universal binaries:
>
> "Method and apparatus for architecture independent executable files"
>
> http://www.google.com/patents/about?id=MQQnAAAAEBAJ
> http://www.google.com/patents/about?id=b3wiAAAAEBAJ
>
> (Patent 5432937, 5604905)
>   
Hmm... looks like patents talks about objects that stored in one file 
with arch-independent header.
My implementation (that is differ to Ryan's) do not use any headers 
except ELF header and just 3 bytes in it to store next location. So, 
it's patent clear.

PS. Patents is evil. This is very common way to store different arch 
binaries...

Rgds,
Anton
