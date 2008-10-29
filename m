Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYJ2XDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYJ2XDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYJ2XCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:02:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54914 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933AbYJ2XBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:01:44 -0400
Message-ID: <4908EA70.8080609@cs.helsinki.fi>
Date: Thu, 30 Oct 2008 00:57:52 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] w35und: remove timer wrappers
References: <Pine.LNX.4.64.0810292009370.16596@melkki.cs.Helsinki.FI> <20081029213607.GB1976@elf.ucw.cz>
In-Reply-To: <20081029213607.GB1976@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2008-10-29 20:10:10, Pekka J Enberg wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> This patch removes the OS_TIMER and related wrappers from driver code. The
>> patch also changes the code to use msecs_to_jiffies() for setting up
>> timer->expires.
>>
>> Cc: Pavel Machek <pavel@suse.cz>
> 
> It also moves LED handling function.
> 
> ACK.

Oh right. That's because I made all the timer functions static and 
wanted to avoid a forward declaration.

			Pekka
