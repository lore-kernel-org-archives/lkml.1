Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbXHZPwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbXHZPwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 11:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXHZPwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 11:52:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42089 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXHZPwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 11:52:46 -0400
Date: Sun, 26 Aug 2007 17:52:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Fred Tyler <fredty8@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <466ad3f90708260851u5d8ac58duc4072b71ebf78fc8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr>
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
 <466ad3f90708260851u5d8ac58duc4072b71ebf78fc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 11:51, Fred Tyler wrote:
>On 8/26/07, Fred Tyler <fredty8@gmail.com> wrote:
>> I think I've come across a memory leak in 2.6.20. I've upgraded to the
>> latest 2.6.20.17, but it didn't seem to help.
>
>Sorry to keep replying to my own post, but further investigation
>suggests that the memory losses may be occurring at times of heavy
>filesystem access. The machines in question run rsyncs of hundreds of
>thousands of files every few hours, and I'm starting to think that the
>memory loss occurs during these times. I don't know how I'd go about
>proving this though...

Please rule out filesystem caches by issuing
	sync;
	echo 3 >/proc/sys/vm/drop_caches;



	Jan
-- 
