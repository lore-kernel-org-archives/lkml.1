Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbXEUQLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbXEUQLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbXEUQL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:11:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:21207 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbXEUQL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qGdDIGe6Dyb+9MjY0i+rMcfBJBDZAZUnxUWkXmG2jR1yNxGH0ScNvRRdn6QpuZLR518FkkDCjd9ZjdrGILnQz2JKZ37p6StsKPUrVbIPr0A51FavHe9xoOCPTHU1pIKCkVuF1ES6Z6J2kmL4H7u65A9Kj9wdpZJbR1sYYDXeblE=
Message-ID: <4651C4A1.6000101@gmail.com>
Date: Mon, 21 May 2007 18:11:13 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org, alan@redhat.com, bzolnier@gmail.com,
       jgarzik@pobox.com
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com> <4651B834.3060702@gmail.com>
In-Reply-To: <4651B834.3060702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, good question. I do not have any other PCMCIA device to test.
The only other device I have is a Cardbus Wi-Fi adapter without Linux 
support (Marvell). If I insert that adapter lspci seems to list it 
properly, but without resorting to ndiswrapper I have no way of testing 
it. In any case, seeing how Cardbus is PCI based this is probably 
pointless to resolving this issue.

Would any other log data from the controller initialization or lspci help?

Tejun Heo wrote:
> Robert de Rooy wrote:
>   
>> This gets a little bit further again, but now I get lots of new errors....
>>     
>
> Alright, this doesn't seem to be the CF reader's problem anymore.  It
> seems the PCMCIA controller isn't passing interrupts properly.  Does any
> other device work in the slot?
>
>   

