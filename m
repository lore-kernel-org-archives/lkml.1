Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYADWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYADWFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYADWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:04:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYADWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:04:52 -0500
Message-ID: <477EAD37.4070903@zytor.com>
Date: Fri, 04 Jan 2008 14:03:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Andi Kleen <andi@firstfloor.org>, felix-linuxkernel@fefe.de,
       linux-kernel@vger.kernel.org
Subject: Re: memory remapping, 4gb memory on 945gt
References: <20080104154914.GA589@codeblau.de> <p73lk758sri.fsf@bingen.suse.de> <20080104181918.GA21797@gallifrey>
In-Reply-To: <20080104181918.GA21797@gallifrey>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
>>>
>>> Now I can understand this explanation for 32-bit mode, but I'm running
>>> in 64-bit mode.  There should be a way to use the fourth gig under
>>> Linux.  Is there?
>> The chipset limitation applies to 64bit mode as well as to 32bit mode
>> (which actually does not have a 4GB limitation with PAE)
> 
> Note that some system and memory vendors have incorrect statements
> stating that the 3.xGB limit is a 32bit OS issue on these machines
> and it'll all just work fine on 64bit OSs.
> 

Supposedly WinXP-32 doesn't use memory over 4 GB even if it is available 
(a market-segmentation decision of the part of Microsoft, to force 
people to buy WinServer 2003; WinXP SP2 does PAE so there is no 
technical reason.)  This probably has disincentivized hardware vendors 
from providing support for remapping the memory from the aperture above 
the 4 GB mark.  The logic isn't all that trivial, especially if the 
aperture size is configurable, so I can understand why they would punt.

	-hpa
