Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZL0OGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZL0OGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZL0OGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:06:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:5220 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZL0OGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:06:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Hx1NqWNzxx01d535HoJUG0Om+Nh0XfDNTPf3oZWPyoTcCKKYxDf9RfczO5UaifyL/D
         4SdIZg0q4q0MXZoOTzqz6/z2sm8c+H1q3jbFZLsjnoqkEg/lJmGmtdi/jjyii+Ny6Zwb
         BMgYWRwXND//af/JoKoPXJi/9OrI0OIikmmyQ=
Message-ID: <4B376A7F.9010805@gmail.com>
Date: Sun, 27 Dec 2009 15:09:03 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] atarilance: timeout ignored in lance_open()
References: <4B37610F.8050401@gmail.com>
In-Reply-To: <4B37610F.8050401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 27-12-09 14:28, Roel Kluin schreef:
> With `while (--limit > 0)' i reaches 0 after the loop, so upon timeout the
> error was not returned.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/net/niu.c b/drivers/net/niu.c

Oops, forgot to update the subject, please ignore, I'll send another.

Roel
