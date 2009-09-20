Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZITSQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZITSQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZITSQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:16:01 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:39022 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZITSQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LE7qQq1chYIha8fpXVh2z0eoqWu8zL0wQeKKjpqUFyn+1LGajc1mc+ikHrTuuXZSi0
         tIlSXv3bKTdt7sufKpc1emT6D+htnQds8J2aTdSccKX5thJEWkZtC9A2DDZ11uY6lsxU
         L3Vcyk4VPSmKuCsIcjOPf7otScaLePk8PYjXg=
MIME-Version: 1.0
In-Reply-To: <20090920110527.39fd7af5@s6510>
References: <c5bd819b0909180641n7c353b80tc15b9c9fe02d5c95@mail.gmail.com>
	 <20090919233536.f5fb700c.akpm@linux-foundation.org>
	 <20090920110527.39fd7af5@s6510>
Date: Sun, 20 Sep 2009 20:16:02 +0200
Message-ID: <c5bd819b0909201116u5a84c426tdd0f298d7019505d@mail.gmail.com>
Subject: Re: sky2 rx length errors
From: Grozdan <neutrino8@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/20 Stephen Hemminger <shemminger@vyatta.com>:

>
> This error status occurs if the length reported by the PHY does not
> match the len reported by the DMA engine.  The error status is:
>   0x4420100 = length 1090 + broadcast packet...
>
> No idea what is on your network, but perhaps there is some MTU confusion?
> Since martian destination seems related, knowing more about that packet
> might help.
>

Hi,

Thanks for the reply. There's nothing on my home network here. It is
just a direct connection from my PC to my cable modem and there's
nothing in between. I've googled a bit and it seems others also
encounter this problem. I've read a few posts on the Ubuntu bugzilla
where people change the MTU from 1500 to 1492 and this fixes the
problem. However, even with this, some report that the problem is
still there. I did the same and it didn't change anything for me. So I
disabled my onboard NIC and added a 3Com one which has been working
perfectly so far and I think I'll just keep using it instead of the
Marvell one.
