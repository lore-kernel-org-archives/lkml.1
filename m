Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYFYLMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYFYLMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYFYLMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:12:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:28109 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYFYLMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Xkm3fSGWS5larm0Bva4Kvkc9lI9uTsz7CeSeoQcoN93zxUi23Jw4TzpFl8n33yI14S
         Syg9ao+nV0jEhSj0QKvA5yRNNMFKMPLMnwcgb6qLjytmLkKbTOOJI5gT07luW1DQ8ItD
         ybrOiRjQUOmkcSNVrUhDTeA1yE0EaiKCZNDpo=
Message-ID: <48622822.3000300@gmail.com>
Date: Wed, 25 Jun 2008 13:12:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, linville@tuxdriver.com
Subject: Re: Small cleanups
References: <20080625102553.GA2648@elf.ucw.cz> <486227D2.6030801@gmail.com>
In-Reply-To: <486227D2.6030801@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -    if ((ai->APList == NULL) &&
>> -        (ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL)) == NULL)
>> +    if (!ai->APList)
>> +        ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL);
>> +    if (!ai->APList)
>>          return -ENOMEM;
>> -    if ((ai->SSID == NULL) &&
>> -        (ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL)) == NULL)
>> +    if (!ai->SSID)
>> +        ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL);
>> +    if (!ai->SSID)
>>          return -ENOMEM;
> 
> Would you mind sending another patch which would fix the potential leak?

Sorry, ignore this.
