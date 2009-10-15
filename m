Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZJOHZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZJOHZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZJOHZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:25:04 -0400
Received: from smtp108.mail.ukl.yahoo.com ([77.238.184.40]:27765 "HELO
	smtp108.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752150AbZJOHZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:25:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=VMKzY8dNWJGjZQ4GjKSx+kYOJ7njxMMlisTQ1M+ouYQlR3OF9FYYg85NUSIsvdFTNEgf6ApOg5eTa6PpAuRSNfvES9A2FRLFemZK2glPmA2E54AjxnWVVa7Qkg2shDsFzG6nv5X7UmOmkt/2nkWLVmDokdtQNEgvJekRxssjRL4=  ;
X-Yahoo-SMTP: dGJefyiswBAq8gjvkVdDD_Aeiz1oX_mV
X-YMail-OSG: .COi2gMVM1nXzyjax11T9SC3x6JANMKn7e_6p2Kp8HXPprBhmCJuzbdxMtD6KkugGuawyBleswjFxWsuNCmmSAN5MBhQiZg7Kc32cwId.ocsrQ6mchL63aP7Fxoykp4XvmoLn5GlyYxeLJLn3PYkDy6X_siVjXuMERiN4mJi7dFCqTz8d0rQL7CEZK7uFyMSZ9ugWFzQ_Osi8o6HqFReNr0m0OnsiIMp9HQspBKMmc_tOtkfKEUkm3RK29SuXu74
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AD6CE3C.1050504@yahoo.co.uk>
Date: Thu, 15 Oct 2009 10:24:44 +0300
From: Boyan <btanastasov@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       hirofumi@mail.parknet.co.jp
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain> <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain> <4AD4F548.2030506@microgate.com> <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain> <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain> <4AD62DAD.9010604@yahoo.co.uk> <alpine.LFD.2.01.0910141356400.6146@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910141356400.6146@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 14 Oct 2009, Boyan wrote:
>> Works for me. I couldn't reproduce the problem with only this patch on
>> top of  2.6.31.4.
> 
> So just to verify: both the flush_to_ldisc() patch _and_ the 
> "flush_delayed_work()" one fixed the problem for you? And you tested them 
> independently? And you said you could reliably trigger it before?

Yes, both patches independently fix the problem for me.
I've tested with both patches applied too and couldn't trigger the
problem.

