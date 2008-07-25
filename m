Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYGYJXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYGYJXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYGYJXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:23:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:13028 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYGYJXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aT3jFUxwMpEtEpUMkhdzFPQCv9kxlzdEgvmWMqVoNP6R1lqe/ppQmPrON/Bwr2+TQU
         hbe191mgqCkDVgsVs0Fp453PVcDYnrVCG7IRQp4BfLWWjrOP3C330616ZC5xDroEg4H6
         dR9f4EKJlve0Z+q8jWEAw6a2jvSv0rYGzaGrY=
Date: Fri, 25 Jul 2008 10:21:54 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: toralf.foerster@gmx.de
Cc: linux-kernel@vger.kernel.org, alan@redhat.com,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: commit a352def21a642 breaks UML
Message-ID: <20080725092154.GA4950@hack.voiplan.pt>
References: <200807251112.10765.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807251112.10765.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Hello,
>
>that commit produces a make error at my system:
>
>...
>  CC      arch/um/drivers/line.o
>arch/um/drivers/line.c: In function 'line_write_interrupt':
>arch/um/drivers/line.c:366: error: 'struct tty_ldisc' has no member named 'write_wakeup'
>arch/um/drivers/line.c:367: error: 'struct tty_ldisc' has no member named 'write_wakeup'
>make[1]: *** [arch/um/drivers/line.o] Error 1
>make: *** [arch/um/drivers] Error 2

Fixed by: http://lkml.org/lkml/2008/7/24/279

Thanks.

-- 
The opposite of love is not hate, but indifference.
	--Elie Wiesel
