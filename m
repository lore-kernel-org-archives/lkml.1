Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbYC0Vs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbYC0Vs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbYC0VsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:48:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389AbYC0VsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:48:20 -0400
Message-ID: <47EC15AD.7030605@zytor.com>
Date: Thu, 27 Mar 2008 14:46:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: add pci=skip_isa_align command lines.
References: <200803270131.18885.yhlu.kernel@gmail.com>	 <20080327084557.GH15626@elte.hu> <20080327175912.GA9684@us.ibm.com> <86802c440803271107m4327554ct688738c80748d2d7@mail.gmail.com>
In-Reply-To: <86802c440803271107m4327554ct688738c80748d2d7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> at least to use blacklist with x86_64
> 

I propose that we should use a rule like:

if ( DMI_date >= cutoff && !(CONFIG_ISA_SLOTS && ISA slots in DMI) )

	-hpa
