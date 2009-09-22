Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZIVPuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZIVPuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbZIVPuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:50:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:39304 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZIVPuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pdCwvO+tTSk8OwN8ZD5WdoRq4F4vHp5hBX9WyKuODsbGmnYw7bO7xxmh7ahNxh9vcY
         70k8QBMepx3DUWdLJEiwn+TrTpqFOS1fDcv1yeaeRZOqd6hdeBG7BNg1FOhetYF/6/Pm
         qdWgpudF6CpqK72KONzQl5xd3p9+lTcwwrCsw=
Message-ID: <4AB8F238.3040105@tuffmail.co.uk>
Date: Tue, 22 Sep 2009 16:50:16 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-modules@vger.org
Subject: Re: [PATCH 1/4] module: extract __ExPORT_SYMBOL from module.h into
 mod_export.h
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>	 <1253626718-18887-2-git-send-email-alan-jenkins@tuffmail.co.uk> <1253634337.22454.3.camel@desktop>
In-Reply-To: <1253634337.22454.3.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Tue, 2009-09-22 at 14:38 +0100, Alan Jenkins wrote:
>   
>> +
>> +struct kernel_symbol
>> +{
>> +       unsigned long value;
>> +       const char *name;
>> +};
>>     
>
> One relevant checkpatch error above,
>
> ERROR: open brace '{' following struct go on the same line
> #71: FILE: include/linux/mod_export.h:13:
> +struct kernel_symbol
> +{
>
> You have another similar one in patch 4 ,
>
> ERROR: else should follow close brace '}'
> #99: FILE: kernel/module.c:221:
> +               }
> +               else if (cmp < 0)
>
>
> Could you correct those?
>
> Daniel
>   

Sure, thanks.  I'll hold off on resending though, in case there are any
more radical changes needed.

Alan
