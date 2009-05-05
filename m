Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZEENfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZEENfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZEENfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:35:10 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:59335 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZEENfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=AxUCQIa4GJqmyFInTyYjXlFbkdaXsCM612Ei/5UPiTznzF89JckyE6W+WBNAkBzz47
         XABfXGEKOcID7GpauphvjjJBQlRhTVkiVPsEpzkI+vcP+3CMtlQa9B85r8f2OfAvp8IJ
         vUddL1Bm81OZCPZOVkC0sqpCowLMadHvy/5GU=
Message-ID: <4A004088.7000907@gmail.com>
Date: Tue, 05 May 2009 15:35:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: richard@rsk.demon.co.uk, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: p80211wext.c: problem with IW_ENCODE_ALG_WEP
References: <Pine.LNX.4.64.0905051522010.9552@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0905051522010.9552@pc-004.diku.dk>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2009 03:22 PM, Julia Lawall wrote:
> -		if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
> +		if (ext->alg != IW_ENCODE_ALG_WEP) {
>  			pr_debug("asked to set a non wep key :(");

While you're at it, there is a missing \n. Care to post a fix for that too?
