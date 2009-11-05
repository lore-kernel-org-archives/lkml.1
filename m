Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZKEToj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZKEToj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758613AbZKEToj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:44:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38268 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592AbZKEToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:44:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KMCVH/TozUkEzlWGzxeAs+J8J9vlgM9nuNKUdh+O/x/4cROBvhI7Va7LtrKnloHLXW
         xwsAZjdpjho7zkBtf7bDCBdKK4Q2kDWk+5tZBXGEA9GQxfg8ZsCvjUJMfmblJLECqp8n
         j/zgPcux5GXTEVUGKdLxnzwCajIY2yQSkG+WU=
Message-ID: <4AF32B25.4000700@gmail.com>
Date: Thu, 05 Nov 2009 14:44:37 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: paulmck@linux.vnet.ibm.com,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder	Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AF0B0D2.4030905@gmail.com> <20091104214844.GA6714@linux.vnet.ibm.com> <4AF2C266.1010603@gmail.com> <4AF2D0E0.1040903@gmail.com>
In-Reply-To: <4AF2D0E0.1040903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> William Allen Simpson a écrit :
>> As you suggest, I'll use the _bh suffix everywhere until every i is dotted
>> and t is crossed.  Then, check for efficiency later after thorough
>> analysis by experts such as yourself.
>>
>> This code will be hit on every SYN and SYNACK that has a cookie option.
>> But it's just prior to a CPU intensive sha_transform -- in comparison,
>> it's trivial.
>>
> I think you misunderstood my advice ;)
> 
Yes, I misunderstood, but it's clear now.  As I have to re-spin the whole
kit and kaboodle after the recent net-next crashing bug fixes, I'll post
another complete set tomorrow to the net list.

Thanks again (for all messages).
