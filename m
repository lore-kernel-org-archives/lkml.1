Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbYFFTx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbYFFTx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 15:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYFFTxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 15:53:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:1477 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404AbYFFTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 15:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uUjz6Dxarl08IPK6ES0gavKvxIg/73oeTBqZ5Fg8e8e2dmLHtrr7hhpPRZnIU1Cjzf
         l5igqMD45BAR1tMRD+xd+91VOfTvqpsWikOnb+1h6rzG2QtRwaHBD2OFuf3BBN0CFpHG
         OIhYLAlN0oL9CjTYeYzRWOuWi3kDmEmudACX4=
Message-ID: <8bd0f97a0806061253s4ad62aa8j53b448b3d6a4faf4@mail.gmail.com>
Date: Fri, 6 Jun 2008 15:53:18 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: serial/bfin_5xx.c build error
Cc: "Adrian Bunk" <bunk@kernel.org>, "Graf Yang" <graf.yang@analog.com>,
       sonic.zhang@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <386072610806060940r5bea0549va4a0a1ae587777bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606162203.GB2201@cs181133002.pp.htv.fi>
	 <386072610806060940r5bea0549va4a0a1ae587777bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 12:40 PM, Bryan Wu <cooloney@kernel.org> wrote:
> On Sat, Jun 7, 2008 at 12:22 AM, Adrian Bunk <bunk@kernel.org> wrote:
>> Commit 7d01b475ab17018756c8df27c2ee3c220fab05f8
>> (Blackfin Serial Driver: Enable IR function when user application)
>> causes the following build error:
>>
>> <--  snip  -->
>>
>> ...
>>  CC      drivers/serial/bfin_5xx.o
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_init':
>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1209: error: 'struct tty_driver' has no member named 'set_ldisc'
>> make[3]: *** [drivers/serial/bfin_5xx.o] Error 1
>>
>> <--  snip  -->
>>
>> In case it can't be fixed quickly a revert might be an option for 2.6.26.
>>
>
> Graf has already sent me a patch to fix this. After I test it on my
> board, I will send it out for Linus git pull.

i dont think there's anything for us to do on our side.  i thought
Alan was sending the fix out for 2.6.26.
-mike
