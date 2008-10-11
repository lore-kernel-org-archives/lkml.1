Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYJKPfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYJKPfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYJKPfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:35:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:49803 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYJKPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W5x9WuYEsw5N4T8LdWYVnihsMVzS6bRgZ3QZRfve26USnKMrHrZNOkIlZ67dwuWv9O
         tWd+TivHUkR53ox0S/MCsXsZnz0sVS9NBu/LVs6Q6NaufhmLszVHSS6haXyr+tMr+7cl
         X9pKPUbgw9yGYDzAWQ59WKdS/tXCnLh0GIIJE=
Message-ID: <c6740f810810110835i170291c0p6fedc7d65351892e@mail.gmail.com>
Date: Sat, 11 Oct 2008 17:35:33 +0200
From: "Philip Stark" <heller.barde@gmail.com>
To: "Grant Coady" <gcoady.lk@gmail.com>
Subject: Re: 2.6.27 seems to break something with DSL
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b6g1f4dkve11bscth3mon86fagchkqb76m@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c6740f810810110553q75478033ub984651d5509199b@mail.gmail.com>
	 <b6g1f4dkve11bscth3mon86fagchkqb76m@4ax.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/11 Grant Coady <grant_lkml@dodo.com.au>:
> On Sat, 11 Oct 2008 14:53:16 +0200, "Philip Stark" <heller.barde@gmail.com> wrote:
>>first off, my network infrastructure:
>>
>>"internet" --(magic*)-- DSL Modem --(DHCP)-- Router --(DHCP)-- Computer
>>* PPPsomething i guess...
>
> Well I connect via rp-pppoe to a bridged ADSL modem.

My modem deals with all the ppp stuff and just gives out plain
LAN/ethernet/however it is called.

One recent gotcha
> is that iptables userspace has to be updated to match the latest kernel,
> how old is your distro?  What version iptables?  Last I checked 1.4.1.1
> was latest available from netfilter.org.

iptables: 1.4.0
distro: archlinux (rolling release) with testing repo enabled

by the way, i forgot to mention that internet works fine anywhere else
and also i can connect to a http server _inside_ my network :)

>>but i can't browse. that is when i 'wget kernel.org' it resolves the
>>address into the correct IP and then goes on to 'connecting' just to
>>grind to a complete halt. after some time of course it times out.
>
> This could be due to your firewall rules?  More people would have
> noticed if their networking died ;)  (Unless you're running a e1000, all
> bets off).

actually one laptop is running a e1000e... but as said, its also with
wireless...

Philip Stark
