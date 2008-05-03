Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYECWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYECWhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYECWhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:37:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:48928 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbYECWhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:37:39 -0400
Subject: Re: HELP:  Is writeq an atomic operation??
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roland Dreier <rdreier@cisco.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <ada63tw494z.fsf@cisco.com>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
	 <ada63tw494z.fsf@cisco.com>
Content-Type: text/plain
Date: Sun, 04 May 2008 08:37:22 +1000
Message-Id: <1209854242.26383.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 15:46 -0700, Roland Dreier wrote:
> > Is a 64bit write to MMIO registers an atomic operation when using the
>  > writeq API?  
>  > 
>  > My concern is when I send 64bit data via writeq, will it be sent out as
>  > two 32 bit writes?  If so, is it possible that another CPU be sending
>  > the data at the same time.  Meaning can I write the 1st 32bit data from
>  > CPU-A, meanwhile CPU-B is writing his 32bit data at the same time, and
>  > CPU-A didn't complete the full 64bit in one shot.  If this could occur,
>  > is there an API that I can use to make sure the entire data sent in one
>  > atomic operation?
> 
> I don't have an authoritative answer, but I can say that I coded
> drivers/infiniband/hw/mthca and .../mlx4 assuming that writeq() is
> atomic in the sense that you say, and no one has reported any problems.
> 
> But I'm sure no one has stressed the drivers on 64-bit mips or anything
> unusual like that.

Surely only on 64 bits archs right ?

Ben.


