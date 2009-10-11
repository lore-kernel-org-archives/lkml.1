Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZJKRTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZJKRTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZJKRTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:19:47 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:49588 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbZJKRTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pdzLADxaLFX5dcfq5LGugkQ3DVtcTYmKmQ3odZaqaf0filCzimq+T6z+pJvzqAl8M3
         nTUiSHvF6VpHpuqDwkNqM/g8f3V8u8IFc9Ejc92HT7V3gdBgbv0wzRgnLUHxHeG5q4//
         XapCBqdmqQT34tv4ERaXiOfU2AzkYOFJdUMUA=
Message-ID: <4AD2138B.1040003@gmail.com>
Date: Sun, 11 Oct 2009 11:19:07 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linuxtronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: Relegate CONFIG_PAT to EMBEDDED
References: <20091011084311.0ab3c3ea@infradead.org> <adaiqelj20l.fsf@cisco.com>
In-Reply-To: <adaiqelj20l.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2009 11:04 AM, Roland Dreier wrote:
> Makes sense, but given that X86_PAT depends on MTRR
>
>   config X86_PAT
>   	bool
> -	prompt "x86 PAT support"
> +	default y
> +	prompt "x86 PAT support" if EMBEDDED
>   	depends on MTRR
>
> should we give the same treatment to the MTRR option too?  (As far as I
> can tell, MTRR defaults to n in the current Kconfig too)

I think so, you'd have to be fairly insane to want to disable MTRR support..
