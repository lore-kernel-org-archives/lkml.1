Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbZALW7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbZALW7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZALW7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:59:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZALW7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:59:25 -0500
Message-ID: <496BCB60.6040504@zytor.com>
Date: Mon, 12 Jan 2009 14:59:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
References: <20090112213539.GA10720@gambetta> <20090112215701.GH23848@one.firstfloor.org> <20090112224037.GA16585@elte.hu>
In-Reply-To: <20090112224037.GA16585@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

>> Nope it doesn't save memory on most systems because per cpu is only 
>> allocated based on the CPUs that are actually there. And if you have 
>> more than 8 cores you can likely afford a few bytes per CPU.
> 
> No distro kernel will build with less than 8 CPUs anyway so this point is 
> moot.

Except for embedded, which will build for exactly what's in the box.

	-hpa
