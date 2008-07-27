Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYG0Oqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYG0Oqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 10:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYG0Oqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 10:46:42 -0400
Received: from ag-out-0708.google.com ([72.14.246.245]:35894 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYG0Oqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 10:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pec5XCT5y5QIUpMGW5O/npPlVxH97yZc2KJNmrHWi5vvFpvMjLcmaXeohQgEQhR3L6
         rTRX/HTm1lOn1TRF2dCRWvXE6dxBLPhV992hfoFkp99yiAj3j2hsqlRgoaVzNLn1VK3w
         u/dO2RlwSKUDgVTBKfZpzJJGt5jeEdRwE5c/g=
Message-ID: <386072610807270746u401add05p795e7f426d7a3da6@mail.gmail.com>
Date: Sun, 27 Jul 2008 22:46:38 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/3] Blackfin EMAC Driver: add proper __devinit/__devexit markings
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <8bd0f97a0807270603s2d3ac6f7q3735b2ac6e31a22c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217139235-19018-1-git-send-email-cooloney@kernel.org>
	 <1217139235-19018-2-git-send-email-cooloney@kernel.org>
	 <8bd0f97a0807270603s2d3ac6f7q3735b2ac6e31a22c@mail.gmail.com>
X-Google-Sender-Auth: 05aee1889ebfbee8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 9:03 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Sun, Jul 27, 2008 at 2:13 AM, Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/net/bfin_mac.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
>> index 4144343..e18a7ee 100644
>> --- a/drivers/net/bfin_mac.c
>> +++ b/drivers/net/bfin_mac.c
>> @@ -614,7 +614,7 @@ static int bfin_mac_hard_start_xmit(struct sk_buff *skb,
>>         * Is skb->data always 16-bit aligned?
>>         * Do we need to memcpy((char *)(tail->packet + 2), skb->data, len)?
>>         */
>> -       if ((((unsigned int)(skb->data)) & 0x02) == 2) {
>> +       if ((((unsigned int)(skb->data)) & 0x01) == 0) {
>>                /* move skb->data to current_tx_ptr payload */
>>                data = (unsigned int)(skb->data) - 2;
>>                *((unsigned short *)data) = (unsigned short)(skb->len);
>
> i think this unrelated hunk slipped in
> -mike
>

Oops, I messed up something. Fixed now.

Thanks,
-Bryan
