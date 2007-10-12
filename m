Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXJLF5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXJLF5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbXJLF5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:57:10 -0400
Received: from mx01.hansenet.de ([213.191.73.25]:39954 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920AbXJLF5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:57:09 -0400
Message-ID: <470F0CAD.2030308@e-dict.net>
Date: Fri, 12 Oct 2007 07:57:01 +0200
From: Ingo Freund <linux-kernel-news@e-dict.net>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: sometimes very long response times on network interfaces since
 2.6.22
References: <470C724A.9010403@e-dict.net> <470C7898.1060405@cosmosbay.com>
In-Reply-To: <470C7898.1060405@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.10.2007 09:00, Eric Dumazet wrote (please find the answer below the original text):
> Ingo Freund a écrit :
>> Hello,
>>
>> since I switched to kernel 2.6.22 my dell 1750 server
>> with the two onboard BCM5704 network interfaces doesn't
>> work properly anymore.
>> TCP requests sometimes need more than 30 seconds to be answered
>> (or to get away) and the application stops with timeouts.
>> We are talking about two servers connected via Gigabit switch.
>> The timeouts happen up to ten times a day.
>> In the meantime I tried an old 3com 3c905c NIC which showed
>> the same behaviour.
>> I still couldn't figure out in which special situation the
>> communication stops.
>> The only solution ist to boot the old 2.6.21.5 kernel.
>> With this, all runs fine.
>> Did I miss a config issue in the migration to 2.6.22?
>> The machines run in a productive environment and there is
>> not much room (time) to debug, but if needed, I could try
>> if anyone would need more information for help.
>>
> 
> Hi
> 1) A tcpdump would help for sure...
> 2) Could you try 2.6.23
> -

I'm trying 2.6.23 with the same config as 2.6.22.n since yesterday.
The error after on day uptime didn't show up again.
It seems that 2.6.22.n is buggy in some special conditions
concerning high load network traffic. This is not depending on
the used NIC.

Thanks for reading this.
-Ingo.

