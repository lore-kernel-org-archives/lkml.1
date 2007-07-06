Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbXGFVzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbXGFVzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbXGFVyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:54:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:3725 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbXGFVyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:54:54 -0400
Date: Fri, 6 Jul 2007 23:54:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: DervishD <lkml@dervishd.net>
cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about cpufreq governors
In-Reply-To: <20070706205045.GA2778@DervishD>
Message-ID: <Pine.LNX.4.64.0707062353510.1536@fbirervta.pbzchgretzou.qr>
References: <20070706205045.GA2778@DervishD>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 6 2007 22:50, DervishD wrote:
>
>    What I want to know is if I can choose "ondemand" governor instead
>of the recommended for AMD64, namely the "conservative" governor, since
>I will be switching between those two frequencies. I haven't found any
>information about my CPU regarding latency when switching between
>frequencies, so I don't know if I will be gaining anything using the
>"conservative" governor.
>
>    Which governor is better suited for a CPU with only two fid's,
>"ondemand" or "conservative"?

Depends on what you want. ondemand instantly switches when there is
something/nothing to do, while conservative uses a threshold (modeled upon
latency).


	Jan
-- 
