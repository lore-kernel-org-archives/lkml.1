Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYIHTZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYIHTZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbYIHTYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:24:55 -0400
Received: from the2masters.de ([213.146.113.64]:49007 "EHLO
	smtp.the2masters.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYIHTYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:24:55 -0400
X-Greylist: delayed 3005 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2008 15:24:55 EDT
Message-ID: <48C57046.5090509@the2masters.de>
Date: Mon, 08 Sep 2008 20:34:46 +0200
From: Stefan Hellermann <stefan@the2masters.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080822)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [regression] __tick_program_event of hpet is stuck
References: <200809080114.36106.elendil@planet.nl> <200809080313.48910.elendil@planet.nl>
In-Reply-To: <200809080313.48910.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop schrieb:
> On Monday 08 September 2008, Frans Pop wrote:
>   
>> With current git head (v2.6.27-rc5-319-g7686ad5) I'm seeing repeated
>> occurrences of the following on my HP Compaq 2510p laptop. Not seen
>> with earlier kernels, including 2.6.27-rc5.
>>     
>
> I meant repeated as in "after different boots", but I now also see repeats 
> when I leave the system on for some time. It keeps increasing the 
> min_delta_ns to ever higher values.
>
> CE: __tick_program_event of hpet is stuck 1468f1b3c9 1468f1c751
> CE: increasing min_delta_ns 5000 to 10000 nsec
> [...]
> CE: __tick_program_event of hpet is stuck 33576032f74 33576035684
> CE: increasing min_delta_ns 10000 to 20000 nsec
> [...]
> CE: __tick_program_event of hpet is stuck 63242b30d28 63242b35b48
> CE: increasing min_delta_ns 20000 to 40000 nsec
>
> The call trace is basically the same each time.
>   
Exactly the same problem here. This is a Lenovo Thinkpad R61 with 
current git head (7686ad56).

Cheers,
Stefan Hellermann

