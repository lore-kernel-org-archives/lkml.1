Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbXJaNGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbXJaNGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXJaNF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:05:57 -0400
Received: from sacred.ru ([62.205.161.221]:59996 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXJaNF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:05:57 -0400
Message-ID: <47288B6D.4080703@openvz.org>
Date: Wed, 31 Oct 2007 17:04:29 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] Move the UTS namespace under the option
References: <47285FEE.9030001@openvz.org> <472861D3.4060303@openvz.org> <47287C05.5060903@fr.ibm.com>
In-Reply-To: <47287C05.5060903@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 31 Oct 2007 16:02:04 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
>> diff --git a/init/Kconfig b/init/Kconfig
>> index fc76773..d592aa2 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -409,6 +409,13 @@ config NAMESPACES
>>  	  or same user id or pid may refer to different tasks when used in
>>  	  different namespaces.
>>
>> +config UTS_NS
>> +	bool "UTS namespace"
>> +	depends on NAMESPACES
> 
> should we add a 'default y' like in 2.6.23 ?

I think no. This is an experimental stuff, so the ones who really
need it should better say it explicitly.

> C.
> 

Thanks,
Pavel
