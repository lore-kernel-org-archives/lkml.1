Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZJ0EeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZJ0EeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 00:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZJ0EeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 00:34:05 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:47750 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbZJ0EeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 00:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iET0zF4lG/YJkF+0KzX02Eo/MiAoggq/t0o9hmy+Yi2RguDxVTVpt0DtY7/Qn4o+43
         nOsEZ6U2mgqN9A2rEtxbGO9p8yY6Ti6c+F0VaJDbMSwjRX/LG1JeOurfTRHWm9P77OIr
         O1kbZCNyo67tt8AUTaK2wx2oaiADcqcAmhb58=
Message-ID: <4AE6783F.1000400@gmail.com>
Date: Mon, 26 Oct 2009 21:34:07 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <4AE621CB.6000700@yahoo.co.uk> <alpine.LFD.2.01.0910261543400.31845@localhost.localdomain> <200910261945.58027.edt@aei.ca>
In-Reply-To: <200910261945.58027.edt@aei.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Tomlinson wrote:
> On Monday 26 October 2009 18:45:27 Linus Torvalds wrote:
>    
>> On Tue, 27 Oct 2009, Boyan wrote:
>>      
>>> I think it is fixed in 2.6.31.5. I can't reproduce the problem with it.
>>>        
>> It was fixed by mainline commit c8e33141911bf8fe87dc6c92793b9a59b2be0130
>> ("tty: Make flush_to_ldisc() locking more robust"), which got back-ported
>> to 2.6.31.5 as commit 86d23a057.
>>      
>
> I can confirm that the keyboard is no longer missbehaving here  with 31.5
>
> Ed
>
>    
I guess there you have it... everybody
confirms this is fixed.
safe to say yes close, but not until the patch
has been pushed to the main tree..

cheers

Justin P. Mattock
