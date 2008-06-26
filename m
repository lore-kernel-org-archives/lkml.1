Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYFZTA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYFZTA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYFZTAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:00:46 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:34419 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbYFZTAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:00:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=RLBWssDqUxhwdKF+fg6sAjZdoU8UN9/Lh51+7/B9oUXVA7YyAdf+n1aSgBlNaLimp
	oLGBQOdvGlj4cnO9cWeffXG/6PQaQW0pObFG6vIl2VViQisDEzQFGKcGqKqSI/xgl2W
	D0dkLdNDnepYbrJO5T40VVfNzuwcpxAYfoZvkaM=
Message-ID: <4863E370.9020205@seznam.cz>
Date: Thu, 26 Jun 2008 20:44:00 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       vapier.adi@gmail.com, arnd@arndb.de, matthew@wil.cx,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       drepper@redhat.com, linuxppc-dev@ozlabs.org, will.newton@gmail.com,
       hpa@zytor.com, John.Linn@xilinx.com, john.williams@petalogix.com
Subject: Re: [PATCH 46/60] microblaze_v4: termbits.h termios.h
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>	<1214483429-32360-32-git-send-email-monstr@seznam.cz>	<1214483429-32360-33-git-send-email-monstr@seznam.cz>	<1214483429-32360-34-git-send-email-monstr@seznam.cz>	<1214483429-32360-35-git-send-email-monstr@seznam.cz>	<1214483429-32360-36-git-send-email-monstr@seznam.cz>	<1214483429-32360-37-git-send-email-monstr@seznam.cz>	<1214483429-32360-38-git-send-email-monstr@seznam.cz>	<1214483429-32360-39-git-send-email-monstr@seznam.cz>	<1214483429-32360-40-git-send-email-monstr@seznam.cz>	<1214483429-32360-41-git-send-email-monstr@seznam.cz>	<1214483429-32360-42-git-send-email-monstr@seznam.cz>	<1214483429-32360-43-git-send-email-monstr@seznam.cz>	<1214483429-32360-44-git-send-email-monstr@seznam.cz>	<1214483429-32360-45-git-send-email-monstr@seznam.cz>	<1214483429-32360-46-git-send-email-monstr@seznam.cz>	<1214483429-32360-47-git-send-email-monstr@seznam.cz> <20080626141837.0f8f439d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080626141837.0f8f439d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm1<165039430>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK.I'll fix it.

M

>> +++ b/include/asm-generic/termbits.h
>> @@ -0,0 +1,200 @@
> 
>> +/* c_cflag bit meaning */
>> +
>> +#define CBAUD	0010017
>> +#define B0	0000000 /* hang up */
> 
> You need BOTHER in here as well - especially if it is going to be generic.
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 

