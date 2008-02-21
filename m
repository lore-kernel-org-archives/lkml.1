Return-Path: <linux-kernel-owner+w=401wt.eu-S934658AbYBUQDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658AbYBUQDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933070AbYBUQBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:01:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:62884 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760304AbYBUQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=ZRLPzMtcIBbbvcuMXRQRN/BSMGccJ4yYVoyjO7I+z0BoA5kXOFInaTlD7sUFben5Qoxgiabf2KtdxY35lBsrhaCpeW0Ug8wuD1KBBWBzbVgR294Xe+UiBTx3OBdQLk4d0Asqv+5aVK+FznqiHr6B2gHzuKlILewZXktX0QO+xWs=
Message-ID: <47BDA02B.9090702@student.tuwien.ac.at>
Date: Thu, 21 Feb 2008 17:00:43 +0100
From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Raynard Brown <Raynard.Brown@iongeo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible Serial Kernel Bug
References: <C35C6F42A97E0C468C32F3AEE46CFF6403C07989@digiexch03.iodigi.ioroot.tld>
In-Reply-To: <C35C6F42A97E0C468C32F3AEE46CFF6403C07989@digiexch03.iodigi.ioroot.tld>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raynard Brown schrieb:
> 0: uart:16550A port:000003F8 irq:4	tx:72	rx:6
> 1: uart:16550A port:000002F8 irq:3	tx:59	rx:6
> 2: uart:16550A port:000003E8 irq:11	tx:0	rx:0 RTS|DTR
> 3: uart:16550A port:000002E8 irq:10	tx:0	rx:0 RTS|DTR
> 4: uart:16550A port:000004F8 irq:0	tx:59	rx:6
> 
                                                      ^^^^^^^
Could it be that hardware flow control is enabled on the server, while 
it is disabled on the other side? What happens if you disable it with 
stty -F /dev/ttySX -rtscts?

Oliver
