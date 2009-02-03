Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZBCFTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZBCFTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZBCFTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:19:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZBCFTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:19:21 -0500
Message-ID: <4987D3AD.1080605@zytor.com>
Date: Mon, 02 Feb 2009 21:18:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Hicks <mort@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       heukelum@mailshack.com, linux-kernel <linux-kernel@vger.kernel.org>,
       kdb@sgi.com
Subject: Re: [PATCH] x86: push old stack address on irqstack for unwinder
References: <20090130165053.GE7872@alcatraz.americas.sgi.com> <49838F39.6060603@zytor.com> <49839CC8.7060502@zytor.com> <20090131003921.GA13709@elte.hu> <20090131174559.GI7872@alcatraz.americas.sgi.com>
In-Reply-To: <20090131174559.GI7872@alcatraz.americas.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Hicks wrote:
> 
> I was searching around, trying to find out if there was another way for
> kdb to do this, and I think removing the backlink is breaking other
> stuff also.  dump_trace() in dumpstack_64.S is using the same trick as
> KDB to trace out of the interrupt stack:
> 

OK, that makes it a no-brainer.  Applied to tip:x86/urgent, thanks!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

