Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYFBMLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYFBMLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYFBML2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:11:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:10501 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994AbYFBMLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DSmaFIaG3XTpr+7S5P+xja6r5kN7VvBb+mk8WRrMrHM/q20lUOXv8JcRQwam2iC7SolSfBX5otX8RAEpATV69PaLq3YCoyXinLWj0Nd96x4qzw/0o+3HedsSjHs5GfXpLui11dyY7UhQjd591o1FLY1KVCKb+sUMvQ7gBopGYRg=
Message-ID: <961aa3350806020511u78896881raef7f5e12b94c121@mail.gmail.com>
Date: Mon, 2 Jun 2008 21:11:19 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [patch -v2 01/23] sunrpc: use simple_read_from_buffer
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org
In-Reply-To: <20080602053552.GA6592@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080601231329.223608711@gmail.com>
	 <20080601231451.529328123@gmail.com>
	 <20080602053552.GA6592@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +     len = sprintf(tbuf, "%lu\n", cd->flush_time);
>> +
>> +     return simple_read_from_buffer(buf, count, ppos, tbuf, len);
>>  }
>
> Please, switch to seq_file:
>
>        seq_printf(m, "%lu\n", cd->flush_time);
>        return 0;
>
> and that's everything module have to worry about.
>

OK. I'll drop this patch from the patch series.
And I'll send this seq_file convertion in another chance.
