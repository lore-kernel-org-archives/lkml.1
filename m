Return-Path: <linux-kernel-owner+w=401wt.eu-S1764161AbYECRlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764161AbYECRlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764943AbYECRkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:40:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53991 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764350AbYECRkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:40:47 -0400
Message-ID: <481CA392.2080602@zytor.com>
Date: Sat, 03 May 2008 10:40:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Roland Dreier <rdreier@cisco.com>, "Moore\, Eric" <Eric.Moore@lsi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: HELP:  Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>	<ada63tw494z.fsf@cisco.com>	<481BB512.6030101@zytor.com> <20080503153521.1d6705cd@core>
In-Reply-To: <20080503153521.1d6705cd@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> I don't have an authoritative answer, but I can say that I coded
>>> drivers/infiniband/hw/mthca and .../mlx4 assuming that writeq() is
>>> atomic in the sense that you say, and no one has reported any problems.
>>>
>> If you're not under lock you're screwed on a 32-bit platform.
> 
> So what cycles does an MMX, SSE or double float store generate on the
> bus ?
> 

Those do generate 64-bit stores; it's just *really* expensive to do it 
in the kernel.  I have used that trick to test 64-bit hardware in a 
32-bit only system, though.

	-hpa
