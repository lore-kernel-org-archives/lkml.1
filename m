Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYAUXPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYAUXPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYAUXP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:15:27 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:62465 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbYAUXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:15:26 -0500
Message-ID: <47952783.8080505@nortel.com>
Date: Mon, 21 Jan 2008 17:15:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <4794F848.9020402@nortel.com> <47950A71.5010304@candelatech.com>
In-Reply-To: <47950A71.5010304@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jan 2008 23:15:20.0372 (UTC) FILETIME=[7DF4B740:01C85C83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear wrote:
> Chris Friesen wrote:
> 
>> Is there anything else we can do to minimize the latency of network 
>> packet processing and avoid having to crank the rx ring size up so high?
> 
> 
> Why is it such a big deal to crank up the rx queue length?  Seems like
> a perfectly normal way to handle bursts like this...

It means that the latency for handling those packets is higher than it 
could be.  Draining 4096 packets from the queue will take a while.

Ideally we'd like to bring the latency down as much as possible, and 
then bump up the rx queue length to handle the rest.

Chris
