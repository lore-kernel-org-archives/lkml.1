Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYDBQkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYDBQkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbYDBQj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:39:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbYDBQj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:39:58 -0400
Message-ID: <47F3B6B6.9010802@zytor.com>
Date: Wed, 02 Apr 2008 09:39:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: "Huang, Ying" <ying.huang@intel.com>, andi@firstfloor.org,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86_64 boot -v2: Add linked list of struct setup_data
References: <1206672584.13404.25.camel@caritas-dev.intel.com>	<20080329233155.ee909a04.pj@sgi.com>	<1206924877.21451.6.camel@caritas-dev.intel.com> <20080402023947.d4d43f7d.pj@sgi.com>
In-Reply-To: <20080402023947.d4d43f7d.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Huang wrote:
>> On Sat, 2008-03-29 at 23:31 -0500, Paul Jackson wrote:
>>> Huang wrote:
>>>> +/* setup data types */
>>>> +#define SETUP_NONE			0
>>> This define seems unused?
>> I think this can prevent somebody to use 0 as type id.
> 
> Why is it a good idea to prevent a 0 type id?
> 

It is usually handy to have an ID to use as ignore, or not present, and 
for that to be zero.

	-hpa
