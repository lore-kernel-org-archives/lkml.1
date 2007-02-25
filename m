Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXBYR4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXBYR4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbXBYR4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:56:35 -0500
Received: from smtpout07-01.prod.mesa1.secureserver.net ([64.202.165.230]:55509
	"HELO smtpout07-04.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932861AbXBYR4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:56:34 -0500
Message-ID: <45E1CDD0.5080108@seclark.us>
Date: Sun, 25 Feb 2007 12:56:32 -0500
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Michael K. Edwards" <medwards.linux@gmail.com>, davids@webmaster.com,
       v j <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com> <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com> <20070225104211.GB2045@elf.ucw.cz>
In-Reply-To: <20070225104211.GB2045@elf.ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>Hi!
>
>  
>
>>Actually, it's quite clear under US law what a derivative work is and
>>what rights you need to distribute it, and equally clear that
>>compiling code does not make a "translation" in a copyright sense.
>>Read Micro Star v. Formgen -- it's good law and it's funny and
>>readable.
>>
>>I've drafted summaries from a couple of different angles since VJ
>>requested a "translation into English", and I think this is the most
>>coherent (and least foaming-at-the-mouth) I've crafted yet.  It was
>>written as an answer to a private query to this effect:  "I write a
>>POP server and release it under the GPL.  The Evil Linker adds some
>>hooks to my code, calls those hooks (along some of the existing ones)
>>from his newly developed program, and only provides recipients of the
>>binaries with source code for the modified POP server.  His code
>>depends on, and only works with, this modified version of my POP
>>server.  Doesn't he have to GPL his whole product, because he's
>>combined his work with mine?"
>>
>>This is a fundamental misconception.  A <<product>> is not a "work
>>    
>>
>
>Ok, but this is not realistic. I agree that if Evil Linker only adds
>two hooks "void pop_server_starting(), void pop_server_stopping()", he
>can get away with that.
>
>But... how does situation change when Evil Linker does #include
><pop3/gpl_header_file_with_some_inline_functions.h> from his
>binary-only part?
>
>I believe situation in this case changes a lot... And that's what
>embedded people are doing; I do not think they are creating their own
>headers or their own inline functions where headers contain them.
>									Pavel
>  
>
The amount copied has to be significant. A few lines against the 
millions in the kernel would
not be enough to be copyright infringement.

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



