Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZAaQ5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZAaQ5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 11:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZAaQ5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 11:57:25 -0500
Received: from h155.mvista.com ([63.81.120.155]:36927 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752447AbZAaQ5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 11:57:24 -0500
Message-ID: <498482ED.9090800@ru.mvista.com>
Date: Sat, 31 Jan 2009 19:57:17 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>	<20090126191151.18b094e6@lxorguk.ukuu.org.uk>	<49846A36.5000708@ru.mvista.com> <20090131160601.5159579d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090131160601.5159579d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>>> +	if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411) /* FIFO is broken */
>>> +		fifo = 0;
>>> +
>>> +	/* On the later chips the read prefetch bits become no-op bits */
>>> +	pci_read_config_byte(pdev, 0x41, &r);
>>> +	r &= ~fifobit[ap->port_no];
>>>   
>>>       
>>   Why not:
>>
>>        r &= ~fifo;
>>     
>
> Because then it wouldn't clear the bits if they were set already and we
> wanted them off!
>   

   Ah, missed the modification of 'fifo'... :-<

MBR, Sergei


