Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbYCZLOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbYCZLOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbYCZLOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:14:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:18956 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbYCZLOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tFZDIv8wKUFSMrurWmlu+J+wPsS57GZ/2bbRllipP0uJ7AF4/FeLzdFcsbcuVKrPHp5u4gcGD1ZkuqqC3Ie5AGzRRhFWwAep9z5L7YCyZp3bdt7Cta7y2ACaHEXUuEE91bKwk3VSPm7JkvPRoc3u1yBRHkyk/NTqGc4Ac4kuq5Q=
Message-ID: <47EA3008.6020903@gmail.com>
Date: Wed, 26 Mar 2008 12:14:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Al Viro <viro@ZenIV.linux.org.uk>, J?rn Engel <joern@logfs.org>,
       David Miller <davem@davemloft.net>, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch] bkl2mtd: cleanup
References: <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326101452.GA17176@elte.hu> <20080326104821.GS10722@ZenIV.linux.org.uk> <20080326111021.GF17176@elte.hu>
In-Reply-To: <20080326111021.GF17176@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2008 12:10 PM, Ingo Molnar wrote:
>  type
>  function_name(vars...)
>  {
> 
> which tends to stay cleanly 2-line and looks tidier and shorter than 
> the:
> 
>  type function_name(vars...
>                     more vars ...)
>  {
> 
> form. The preferred form is of course:
> 
>  type function_name(vars...)

Anyway I wouldn't mix that bsd style with this one in one particular file. 
(Beside the fact I dislike the BSD one.)
