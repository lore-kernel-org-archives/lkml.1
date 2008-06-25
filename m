Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYFYRta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYFYRta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYFYRtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:49:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYFYRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:49:21 -0400
Message-ID: <48628501.6050203@zytor.com>
Date: Wed, 25 Jun 2008 10:48:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Merge setup_32/64.c into setup.c
References: <200806242213.15310.yhlu.kernel@gmail.com>	 <200806242214.09503.yhlu.kernel@gmail.com>	 <200806250114.09858.yhlu.kernel@gmail.com>	 <20080625153614.GB18796@elte.hu>	 <86802c440806250844s51b50311va1c8e9c9fc1da510@mail.gmail.com>	 <20080625164300.GC6040@elte.hu>	 <86802c440806251028sb9a98e3ncbae3b3130c02fa6@mail.gmail.com>	 <486282A8.5020306@sgi.com> <86802c440806251046g4d5145a2y72aa2b6cd83a98f7@mail.gmail.com>
In-Reply-To: <86802c440806251046g4d5145a2y72aa2b6cd83a98f7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> Ingo want make setup_32.c have everything (in 10 patches), and then
> rename setup_32.c to setup.c and delete setup_64.c
> 
> will move numa related to setup_numa.c or numa.c
> 

FWIW, I personally would like to see initialization-only code moved out 
of arch/x86/kernel at some point.  Right now "kernel" is a catch-all, in 
particular, it mixes drivers, runtime core code, and initialization code.

	-hpa
