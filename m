Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524Ab0AMLDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0AMLDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465Ab0AMLDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:03:40 -0500
Received: from mail-gx0-f228.google.com ([209.85.217.228]:61792 "EHLO
	mail-gx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab0AMLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VF4XVdCGFNGOfnp1K25TJ7p/lr84tY30XJVAuGKZKcB4PVrExOJePXVzsapstl9lk3
         7JOq1mmhhT2j1oWV6hEqAk2m9ZKhR2PmGw8IyJeiqTxrJkHruuBKHGPDmoSetPIjZJfY
         k/ItjQlmZfaZdmNzcCQGvY8b6KR09eI+EZ/xg=
Message-ID: <4B4DA887.5070309@gmail.com>
Date: Wed, 13 Jan 2010 06:03:35 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH 1/2] net: tcp_header_len_th and tcp_option_len_th
References: <4B44FE3C.6060809@gmail.com> <4B450065.4010108@gmail.com> <4B4C519E.2090207@gmail.com> <4B4CB46C.8020502@gmail.com> <4B4CB712.8030806@gmail.com> <4B4D8A24.4070108@gmail.com> <4B4D99B0.8090102@gmail.com>
In-Reply-To: <4B4D99B0.8090102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
  2) You also should know that sizeof() is *strongly* typed (size_t),
> not an "untyped constant".
> 
My apologies, it's fairly early in the morning here -- I meant
"unsigned" rather than "untyped".


> The (int) cast it not only _not_ needed, its also confusing.
> 
I'm sorry for your confusion.  I believe it adds clarity.

Moreover, it's fairly egregious that the old tcp_hdrlen()
contributor didn't take signed versus unsigned into account.

Perhaps we could move along to more substantive issues....

Have you had an opportunity to test PATCH 2/2 in this series?
