Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZCPLKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZCPLKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbZCPLJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:09:51 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:50443 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZCPLJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=A3hVmy7bugQZ5bbz0KuGGdc/wN+HMjemNzyWg8j/t79iTGZNzQ2ev7MTN6AzM5AC7I
         iOZNWne7JrmSq4AA9zJ2wRs/+ACdh2O0DtfLKNuYPpoWZZv8lfw7yWkHSi9AX0Vq8Pzz
         /pZJ96v+Ca8fUd92UNKdyTh0vWAVciTIDUBic=
Message-ID: <49BE3379.2070907@gmail.com>
Date: Mon, 16 Mar 2009 12:09:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Char: isicom, prolong tty reference holding
References: <1237199665-10675-1-git-send-email-jirislaby@gmail.com> <20090316105026.610a0b9a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090316105026.610a0b9a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.3.2009 11:50, Alan Cox wrote:
> isicom: isicom kref leak fix
>
> From: Alan Cox<alan@lxorguk.ukuu.org.uk>
>
> The isicom driver leaks a kref on the shutdown path. Drop the additional
> kref we took
>
> Signed-off-by: Alan Cox<alan@lxorguk.ukuu.org.uk>

Acked-by: Jiri Slaby <jirislaby@gmail.com>
