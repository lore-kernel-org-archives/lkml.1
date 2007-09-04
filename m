Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbXIDPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbXIDPJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXIDPJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:09:12 -0400
Received: from smtp.opengridcomputing.com ([71.42.183.126]:45635 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbXIDPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:09:11 -0400
Message-ID: <46DD7516.4090905@opengridcomputing.com>
Date: Tue, 04 Sep 2007 10:09:10 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Divy Le Ray <divy@chelsio.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23 0/2] cxgb3 - Fix dev->priv usage
References: <46D4F12C.7090409@chelsio.com> <ada3ay26gys.fsf@cisco.com> <46D5B296.8020703@chelsio.com>
In-Reply-To: <46D5B296.8020703@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

We'll work on upgrading you to T3B2 boards as well.

Stay tuned.

Steve.



Divy Le Ray wrote:
> Roland Dreier wrote:
>>
>> Looks OK to me but I would just roll up the second patch into the
>> first patch and let Jeff merge it as one commit.  There's no point in
>> creating an intermediate tree that doesn't build -- it just breaks git
>> bisect for no useful purpose.
>>
> 
> Okay, Jeff agrees too, I'll do so.
> 
>> Also as a side note, when trying to test this I got the message
>>
>>     could not load TP SRAM: unable to load t3a_protocol_sram-1.0.44.bin
>>
>> and you guys seem to only have t3b protocol sram images on your web
>> site.  Could you send me the t3a file (or swap out my T3A boards for
>> T3B boards ;)?
>>
> I'd rather fix the driver then:
> First, HW folks tell me that there is no need for engine
> microcode update for T3A.
> Moreover, there is a bug when the file name is constructed.
> We have T3B and T3B2 board revs, the driver looks for
> t3b_protocol_sram-1.0.44.bin for T3B2 boards and defaults to
> t3a_protocol_sram-1.0.44.bin even for T3B boards.
> I submitted a patch fixing this in netdev#upstream.
> I should propose the fix for 2.6.23 instead.
> 
> Cheers,
> Divy
> 
