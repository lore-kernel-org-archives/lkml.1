Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbZEEVXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbZEEVXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZEEVXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:23:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56437 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZEEVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:23:09 -0400
Message-ID: <4A00ADDE.9000908@zytor.com>
Date: Tue, 05 May 2009 14:21:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] x86: Reduce the default HZ value
References: <1241462661.412.8.camel@alok-dev1>
In-Reply-To: <1241462661.412.8.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Hi,
> 
> Given that there were no major objections that came up regarding
> reducing the HZ value in http://lkml.org/lkml/2009/4/27/499. 
> 
> Below is the patch which actually reduces it, please consider for tip.
> 

What is the benefit of this?

I can see at least one immediate downside: some timeout values in the 
kernel are still maintained in units of HZ (like poll, I believe), and 
so with a lower HZ value we'll have higher roundoff errors.

	-hpa
