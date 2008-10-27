Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbYJ0Alq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYJ0Alq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 20:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYJ0Ali
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 20:41:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYJ0Alh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 20:41:37 -0400
Message-ID: <49050D7F.4000906@zytor.com>
Date: Sun, 26 Oct 2008 17:38:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PAT and MTRRs
References: <200810262246.21807.dvadell@linuxclusters.com.ar>	<20081026171210.7b3b096a@infradead.org>	<49050995.4080508@zytor.com> <20081026173458.44c5a036@infradead.org>
In-Reply-To: <20081026173458.44c5a036@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>>
>> Now, if it wasn't for the braindamage called ACPI and SMM, we could
>> have cleared the MTRR settings and just used PAT...
> 
> yeah.. one thing we need  to investigate is if we can set the default
> "no mtrr coverage" value to cached
> (and also.. to check we don't set that to uncached if the bios had it
> set to cached..)
> 

Well, in the end it comes down to the same thing: SMM expects the memory 
map to reside in MTRRs.  We can "sanitize" the memory map, but we can't 
throw it out the window like what we really should be able to.

	-hpa
