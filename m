Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbXJ2Tpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbXJ2Tpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXJ2Tlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:41:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44359 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbXJ2Tli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:41:38 -0400
Message-ID: <4726376E.3080608@garzik.org>
Date: Mon, 29 Oct 2007 15:41:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] netdrvr/ibmlana: move away from legacy MCA API
References: <47dcd058deaaf90802c720df243f5c8b26ed9de3.1193686354.git.jeff@garzik.org> <cbe6f335b6d7f4199e235a4925d1c931dd512fe5.1193686354.git.jeff@garzik.org> <Pine.LNX.4.64.0710292039020.26070@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710292039020.26070@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 29 2007 15:33, Jeff Garzik wrote:
>> +#if 0 /* info available elsewhere, but this is kept for reference */
> 
> It is available in the git history, yes, is it still needed for reference?

it's there to see if anyone complains at its removal :)


>> +static short ibmlana_adapter_ids[] __initdata = {
>> +	IBM_LANA_ID,
>> +	0x0000
>> +};
>> +
>> +static char *ibmlana_adapter_names[] __initdata = {
>> +	"IBM LAN Adapter/A",
>> +	NULL
>> +};
> 
> Can this be const?

Not with the initdata marker, no.

	Jeff



