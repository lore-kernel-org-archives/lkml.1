Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZCKP0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZCKP0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZCKP0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:26:46 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:1467 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZCKP0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gYGqkJyh445deVNJ9VNM99qA0XYZzYoK1eNhtPe4cUfNKuhhcLrSwqLRXfH+q0O9Is
         I6YuUlYjWxCTX+i0G34wvLTqJZ3kSpvQeWFdd0TWxiq0fTEPgDkBOWVMfnIk5VSKCBK9
         CVgMsiepoGfuEi4J4TCy4mOZc3pJvPi7DHkz0=
Message-ID: <49B7D830.10601@gmail.com>
Date: Wed, 11 Mar 2009 16:26:40 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Breno Leitao <leitao@linux.vnet.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/1] icom: Removing unused variables and converting space
 to tabs
References: <49B7D63E.9050006@linux.vnet.ibm.com>
In-Reply-To: <49B7D63E.9050006@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.3.2009 16:18, Breno Leitao wrote:
> --- a/drivers/serial/icom.c
> +++ b/drivers/serial/icom.c
> @@ -1022,7 +1022,6 @@ static void icom_send_xchar(struct uart_port *port, char ch)
>   			writeb(ch,&ICOM_PORT->dram->xchar);
>
>   			/* flush write operation */
> -			xdata = readb(&ICOM_PORT->dram->xchar);

NACK. Did you read the comment above?
