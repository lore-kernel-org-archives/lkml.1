Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbYHOQht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbYHOQht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYHOQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:37:41 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33656 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbYHOQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:37:41 -0400
Message-ID: <2487.69.2.248.210.1218816837.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080815122510.GF20442@elte.hu>
References: <200808140614.m7E6EcDS006264@wolfmountaingroup.com>
    <84144f020808140139v691e6590idd79995168af4e9e@mail.gmail.com>
    <44303.166.70.238.45.1218724556.squirrel@webmail.wolfmountaingroup.com>
    <20080815122510.GF20442@elte.hu>
Date: Fri, 15 Aug 2008 10:13:57 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc3 26/29] mdb: export task_curr
From: jmerkey@wolfmountaingroup.com
To: "Ingo Molnar" <mingo@elte.hu>
Cc: jmerkey@wolfmountaingroup.com, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, jason.wessel@windriver.com
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> >> +EXPORT_SYMBOL_GPL(task_curr);
>> >> +#endif
>> >
>> > We usually don't export symbols conditionally, especially in core
>> kernel
>> > code.
>> >
>>
>
> FYI, there's a built-in kernel debugger in the upstream kernel already:
> kernel/kgdb.c - and it does not need that export.

I do not need this export either -- unless mdb runs as a kernel module -
which kdb and kgdb cannot do today ...

Jeff

>
> 	Ingo
>


