Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZCDJv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZCDJv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZCDJvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:51:19 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:42061 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZCDJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IQjHJ6uzqZTphAJ5M+M2wgY0xuJ2S/xVGQyygjVeyZIVAeXpwVN0BOy5l+e7tCGzHb
         5Cs1Vd2bB48/AAYPUvbG2IhaG8Lu5u7LW+38dsBUQ+AK9tacsuHXufKbrAfCvevErO9u
         AVhKc+qMtu+oNLootp37tun9oWa6ShbrMRqgI=
MIME-Version: 1.0
In-Reply-To: <49AE48B4.8010907@kernel.org>
References: <49AE485B.8000902@kernel.org> <49AE48B4.8010907@kernel.org>
Date: Wed, 4 Mar 2009 11:51:14 +0200
X-Google-Sender-Auth: 01d2c4fa6d4e5f23
Message-ID: <84144f020903040151o7793bd92k9b8849bf9155eb43@mail.gmail.com>
Subject: Re: [PATCH] x86: make 32bit init_memory_mapping range change more 
	like 64bit
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 11:24 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Impact: clean up
>
> make code more readable and more like 64bit
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This is a nice step towards unifying 32-bit and 64-bit
init_memory_mapping() implementations!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
