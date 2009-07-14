Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbZGNVSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbZGNVSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 17:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZGNVSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 17:18:48 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:39458 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbZGNVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 17:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sSyY1pz+OlkHpwm3oNZhwMwTBzclt4fjXOlE+n8JHJvQxq+WyazlQ+Su+AqGRVc6ch
         1oXdKKhL5ngTqy6we+5J9t48dXY/BkujsfLC4vJbBFed/zoIKiPFI8YLyHsMKNAs7bxn
         ZA3YjuLtxiBCbPn/W6iuoWrFkdaeTWK4tkY0A=
Message-ID: <4A5CF632.7080105@gmail.com>
Date: Tue, 14 Jul 2009 23:18:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] NET: sungem, use spin_trylock_irqsave
References: <1247520220-31960-1-git-send-email-jirislaby@gmail.com>	<1247520220-31960-2-git-send-email-jirislaby@gmail.com> <20090714.141020.34896663.davem@davemloft.net>
In-Reply-To: <20090714.141020.34896663.davem@davemloft.net>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2009 11:10 PM, David Miller wrote:
>> -	if (!spin_trylock(&gp->tx_lock)) {
>> +	if (!spin_trylock_irqsave(&gp->tx_lock)) {
> 
> (hint: type 'make' before you send patches!!!!)

Grr, I did but my bash_history shows that I built wrong subtree. My
apologies.
