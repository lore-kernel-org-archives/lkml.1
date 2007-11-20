Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbXKTJRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbXKTJRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXKTJRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:17:05 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40369 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXKTJRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:17:03 -0500
Date: Tue, 20 Nov 2007 10:17:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mike Frysinger <vapier.adi@gmail.com>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: netconsole=y and rtl8139=m
In-Reply-To: <8bd0f97a0711192357o3c3e66c3w97e08a2a96bac1e4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711201015520.32378@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711200815220.32378@fbirervta.pbzchgretzou.qr>
 <8bd0f97a0711192357o3c3e66c3w97e08a2a96bac1e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 20 2007 02:57, Mike Frysinger wrote:
>On Nov 20, 2007 2:17 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>> I get this during boot:
>>
>> [   40.821740] netconsole: eth1 doesn't exist, aborting.
>>
>> Given that CONFIG_NETCONSOLE=y and CONFIG_8139TOO=m, I can imagine.
>> Is there a way to get this working without making 8139TOO=y or
>> NETCONSOLE=m?
>
>i guess that depends on what your expectations are.  what do you think
>would qualify as a fix ?  that netconsoles could get added/removed
>dynamically based on network drivers being loaded/unloaded instead of
>netconsole being set up just once at netconsole init time ?

If I can get that bonus, yes :)

Also, does netconsole cope with interface renames?


thanks,
jan
