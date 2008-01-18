Return-Path: <linux-kernel-owner+w=401wt.eu-S1764676AbYARVwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764676AbYARVwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762229AbYARVwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:52:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:38868 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761288AbYARVv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:51:59 -0500
Cc: Jochen Friedrich <jochen@scram.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>
Message-Id: <EC416CBA-9200-4D71-8D95-39798937203D@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080118204030.48fbb683@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH/RFCv2] [POWERPC] Add support for freescale watchdog to CPM serial driver.
Date: Fri, 18 Jan 2008 15:51:38 -0600
References: <478F4AE3.5090803@scram.de> <20080118183905.2d5d8474@lxorguk.ukuu.org.uk> <4790F44F.8020009@scram.de> <20080118204030.48fbb683@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 18, 2008, at 2:40 PM, Alan Cox wrote:

> On Fri, 18 Jan 2008 19:47:43 +0100
> Jochen Friedrich <jochen@scram.de> wrote:
>
>> Hi Alan,
>>
>>>> If a freescale watchdog device node is present, reset the watchdog
>>>> while waiting for serial input.
>>>
>>> Why ? We normally rely on user space for watchdog management as  
>>> only the
>>> fact user space is behaving really proves a box is happy ?
>>
>> This is in the boot wrapper code, not in the linux kernel.
>
> Ok now that makes sense, thanks

So I'll ask, what serial input are you waiting for from the boot  
wrapper?

- k
