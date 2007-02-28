Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXB1Oym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXB1Oym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbXB1Oym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:54:42 -0500
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:37187 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932928AbXB1Oyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:54:41 -0500
In-Reply-To: <45E592DC.9060700@freescale.com>
References: <45E46976.6060600@freescale.com> <29c13109971547687159078eacdea008@kernel.crashing.org> <45E592DC.9060700@freescale.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>,
       Torben.Mathiasen@hp.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 15:54:37 +0100
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>           46 = /dev/ttyCPM0        PPC CPM (SCC or SMC) - port 0
>>>              ...
>>> -         47 = /dev/ttyCPM5        PPC CPM (SCC or SMC) - port 5
>>> +         49 = /dev/ttyCPM5        PPC CPM (SCC or SMC) - port 5
>> If CPM0 is 46, then CPM5 is not 47, but not 49 either.
>> Unless it's not CPM5 but CPM3?
>
> Honestly, I don't know.  I was just correcting the obvious typo (47 
> instead of 49).

It's obvious it shouldn't be 47, but it's not obvious it
should be 49 instead.

> I'll try to get an answer from someone, but I'm no CPM expert.

Adding linuxppc-embedded to the CC:, someone there surely knows.


Segher

