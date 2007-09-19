Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbXISNgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbXISNgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXISNgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:36:36 -0400
Received: from mail.tmr.com ([64.65.253.246]:52236 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbXISNgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:36:35 -0400
Message-ID: <46F126BE.5060507@tmr.com>
Date: Wed, 19 Sep 2007 09:40:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mchan@broadcom.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
References: <1190141114.9540.216.camel@dell>	<20070918.112337.74737433.davem@davemloft.net>	<1190145951.9540.230.camel@dell> <20070918.122150.124083496.davem@davemloft.net>
In-Reply-To: <20070918.122150.124083496.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Michael Chan" <mchan@broadcom.com>
> Date: Tue, 18 Sep 2007 13:05:51 -0700
> 
>> The bnx2 firmware changes quite frequently.  A new driver quite often
>> requires new firmware to work correctly.  Splitting them up makes things
>> difficult for the user.
>>
>> The firmware in tg3 is a lot more mature and I don't expect it to
>> change.  I think tg3 is better suited for using request_firmware().
> 
> Like I said, I think neither should change and the driver should
> be fully functional when built statically into the kernel.
> 
Is that a suggestion that the driver work differently when built as a 
module or built in? I've seen that behavior many time over the years, 
but it usually not deliberate. ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
