Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYDJMdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYDJMdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYDJMdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:33:15 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:16977 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbYDJMdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:33:15 -0400
Message-ID: <47FE0906.8080102@fr.ibm.com>
Date: Thu, 10 Apr 2008 14:33:10 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
References: <20080409222611.GA28087@us.ibm.com> <47FD5899.2040206@zytor.com> <20080410010717.GA28477@us.ibm.com> <47FD6921.6090408@zytor.com>
In-Reply-To: <47FD6921.6090408@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> sukadev@us.ibm.com wrote:
>>>
>>> If you're going to make it a 64-bit pass it in as a 64-bit number,
>>> instead of breaking it into two numbers.
>>
>> Maybe I am missing your point. The glibc interface could take a 64bit
>> parameter, but don't we need to pass 32-bit values into the system
>> call on 32 bit systems ?
> 
> Not as such, no.  The ABI handles that.  To make the ABI clean on some
> architectures, it's good to consider a 64-bit value only in positions
> where they map to an even:odd register pair once slotted in.

OK. I didn't know that. I took sys_llseek() as an example of an interface 
to follow when coded clone64(). 

Thanks,

C. 
