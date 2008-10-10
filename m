Return-Path: <linux-kernel-owner+w=401wt.eu-S1764124AbYJJUgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764124AbYJJUgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761959AbYJJUgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:36:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761664AbYJJUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:36:20 -0400
Message-ID: <48EFBCA4.6020008@zytor.com>
Date: Fri, 10 Oct 2008 13:35:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stefan Bader <stefan.bader@canonical.com>, stable@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in	used_vectors
 bitmap
References: <48EFB4B2.2020508@canonical.com> <20081010201805.GC32164@kroah.com>
In-Reply-To: <20081010201805.GC32164@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Is there a problem with being assigned to IRQ0 in situations like this?
> 

On PCs, IRQ 0 is dedicated to use for the PIT.

	-hpa
