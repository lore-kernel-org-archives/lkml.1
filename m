Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZHDI2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZHDI2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZHDI2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:28:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:9353 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZHDI2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <4A77E9FA.7030503@bigtelecom.ru>
References: <6c039e090907231439t1def08a4n10978733bee55bec@mail.gmail.com>
	 <20090727144402.513369f1.akpm@linux-foundation.org>
	 <1248912621.13447.12.camel@merlyn>
	 <20090803.212323.256579233.davem@davemloft.net>
	 <6c039e090908040036j38666152y2db1d4c55529eaff@mail.gmail.com>
	 <4A77E9FA.7030503@bigtelecom.ru>
Date: Tue, 4 Aug 2009 16:28:34 +0800
Message-ID: <6c039e090908040128l7bdaf45j3305e5e392562b85@mail.gmail.com>
Subject: Re: [PATCH] net: Keep interface binding when sending packets with 
	ipi_ifindex = 0
From: =?UTF-8?B?Q2hpYS1jaGkgWWVoICjokYnlrrbpvYop?= <chiachi@android.com>
To: Badalian Vyacheslav <slavon@bigtelecom.ru>
Cc: David Miller <davem@davemloft.net>, john.dykstra1@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 4, 2009 at 3:57 PM, Badalian Vyacheslav<slavon@bigtelecom.ru> wrote:
>
> Hello
> Sorry if its my mistake or i someone not understand :)
>
> if (ipc->oif && info->ipi_ifindex != ipc->oif)
>        // if match: info->ipi_ifindex != ipc->oif
>        return ...
> else
>        // else match: info->ipi_ifindex == ipc->oif
>        // but you do
>        ipc->oif = info->ipi_ifindex;
>        // why if you else match allready check for it?
>
> Thanks

Hi Badalian,

Consider ipc->oif = 0 before the if-condition. :)

Chia-chi
