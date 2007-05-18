Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbXERLN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbXERLN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXERLNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:13:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:3453 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbXERLNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b+dH24Eidlk7HJqSej5WvCavElu2HKDl3vUlOBmWIFgiGxguVngRUCyTBJRZ4UCnjz3XBuqCn3kdAqo3taC9Si23nVsMVjKkSAQ1Zo0u9oncQeqdjhlYw64yu8/wPPsCa9zEym9QHJj3PV1ZCY/wHO4O9DQ02ILodClGlSJdk04=
Message-ID: <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
Date: Fri, 18 May 2007 16:43:50 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: Fork Bombing Attack
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4051.1179414105@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>
	 <4051.1179414105@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All
           I tried to execute a program which creates 8152 process.(
i=0; while( i<14) i++ fork(); )  with ulimit 8200. This program
created 8152 processes and then stopped and came back to command
prompt. this proves that my machine do have sufficient resources to
create 8000 processes.

           I found one more interesting thing on the same machine
having FC6 distribution and Linux Kernel 2.6.18. i have set "ulimit -u
100". after setting this limit i tried to execute fork bombing program
with guest account. after executing it

expected result:-  guest uesr should not able to fork another single
process when it reaches to 100 processes count.

actual result :-  kernel allow me to create another processes without
giving error. due to this i tried to execute same fork bombing program
on another terminal with guest account and this fork bombing attack
killed the box completely and machine needed reboot.

will any please tell me why this is so?

Regards
Anand

On 5/17/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 17 May 2007 20:15:32 +0530, Anand Jahagirdar said:
> > Hello All
> >               I have set per user process limit ( ulimit) for both
> > root and guest account as 8000 by using option ulimit -u 8000.this is
> > Hard limit.  still fork bombing attack killed the box and machine
> > needed reboot. will any body please tell me why this is so? i have
> > tried all this attack on machine with FC6 and Linux kernel 2.6.18.
>
> Convince me that your machine in fact has sufficient resources to spawn 8000
> processes.
>
> Then retry it with "ulimit -u 100", and then do a binary search from 100 to 8000
> to find out what value it stops working at.
>
>
