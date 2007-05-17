Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbXEQU6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbXEQU6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEQU6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:58:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40682 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbXEQU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:58:38 -0400
Message-ID: <464CC209.4060500@cs.helsinki.fi>
Date: Thu, 17 May 2007 23:58:49 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: "=?UTF-8?B?SsO2cm4gRW5nZWw=?=" <joern@lazybastard.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
References: <20070515151919.GA32510@lazybastard.org> <Pine.LNX.4.64.0705161319060.5152@sbz-30.cs.Helsinki.FI> <20070516122603.GE5472@lazybastard.org> <84144f020705160536i189f6206sffc964a145177da7@mail.gmail.com> <20070516132035.GJ5472@lazybastard.org>
In-Reply-To: <20070516132035.GJ5472@lazybastard.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Compressing random data will actually enlarge it.  If that happens I
> simply store the verbatim uncompressed data instead and mark it as such.
> 
> There is also demand for a user-controlled bit in the inode to disable
> compression completely.  All those .jpg, .mpg, .mp3, etc. just waste
> time by trying and failing to compress them.

So any sane way to enable compression is on per-inode basis which makes 
me still wonder why you need per-object compression.
