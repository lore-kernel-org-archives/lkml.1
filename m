Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbXDRGYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbXDRGYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXDRGYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:24:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:26950 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbXDRGYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=STCX1I+6jDNXntTbmjZNqzs1yXxKUqzlDswKiv6zUElcZp8Exldg2vzJjs4VrUHdVj5W46itReRdFz0JnvDaN4p7uvG/fUG1XhPZCPa5j1nIE0XFrYV18TSmablSkiQLUq7E35Z80kY6toKMUYoqJzcFpq9kogmyR/dpAFZ8w/4=
Message-ID: <84144f020704172324u725f6b22u4b1634203d65167c@mail.gmail.com>
Date: Wed, 18 Apr 2007 09:24:15 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pavel Emelianov" <xemul@sw.ru>
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M (v2)
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>, "Linux MM" <linux-mm@kvack.org>,
       devel@openvz.org, "Kirill Korotaev" <dev@openvz.org>
In-Reply-To: <4624E8F4.2090200@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4624E8F4.2090200@sw.ru>
X-Google-Sender-Auth: 41ecbf9a99062ac9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Pavel Emelianov <xemul@sw.ru> wrote:
> The out_of_memory() function and SysRq-M handler call
> show_mem() to show the current memory usage state.

I am still somewhat unhappy about the spinlock, but I don't really
have a better suggestion either. Other than that, looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
