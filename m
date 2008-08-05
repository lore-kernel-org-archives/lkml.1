Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbYHECcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbYHECcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYHECXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:23:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbYHECXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:23:03 -0400
Message-ID: <4897B7DB.7040507@zytor.com>
Date: Mon, 04 Aug 2008 19:15:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH 2/5] x86: Coding style fixes to arch/x86/kernel/bios_uv.c
References: <20080802212406.047e8ae6@paolo-desktop> <48952DB3.20101@zytor.com>	 <48958DC2.7070506@s5r6.in-berlin.de>	 <m3iquigvqc.fsf@maximus.localdomain> <4d8e3fd30808030521t351a8564yfb93211f7239613c@mail.gmail.com>
In-Reply-To: <4d8e3fd30808030521t351a8564yfb93211f7239613c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi wrote:
> 
> _much worse_? Wow, I thought the opposite.
> Anyway, that's just a coding style patch, feel free to simply not apply it as
> it's really a matter of personal taste but be sure that I'm not
> blindly changing the code
> accordingly to checkpatch. That might be almost true when I started
> doing this kind of patches months
> ago but it's definitely not true anymore.
> 

In this case, the real problem is that the original code used a switch 
statement where it really should have used a table.

	-hpa
