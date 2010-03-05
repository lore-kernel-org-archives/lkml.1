Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0CEJHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:07:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:47722 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0CEJHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:07:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uWkRlthYp5SiKmBuC9kvPl63HmMwDz3eJqqp11KII2Nddk27bUadg51Q86+pL1+dRo
         hlcCe0wDPN6u0HNMSomTEM7YIWeRcbui0nqabyN2/fI4yJFUApefqusBsnF75TJ0zuk/
         AMcLrAVEQPdBKWxblsKCQH0+hF9bt5nB33lfo=
Message-ID: <4B90C9BE.1030407@gmail.com>
Date: Fri, 05 Mar 2010 10:07:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-11.2 Thunderbird/3.0.1
MIME-Version: 1.0
To: Johannes Sixt <j.sixt@viscovery.net>
CC: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gitignore broken in git 1.7.0.1: slash checks leading dirs
References: <4B90C701.3070308@gmail.com> <4B90C974.2050405@viscovery.net>
In-Reply-To: <4B90C974.2050405@viscovery.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 10:05 AM, Johannes Sixt wrote:
> Jiri Slaby schrieb:
>> having 'linux' line in .gitignore makes 'include/linux/vga_switcheroo.h'
>> to be ignored
> 
> That's the behavior that I would expect.
> 
>> though the documentation says:
>> ***
>> If the pattern does not contain a slash /, git treats it as a shell
>> glob pattern and checks for a match against the pathname without
>> leading directories.
>> ***
> 
> and this citation confirms my expectation. Note that it says "pathname",
> not "filename". 'include/linux' is a "pathname".

What are 'leading directories' then?

-- 
js
