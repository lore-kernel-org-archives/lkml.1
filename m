Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZBQTLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZBQTLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZBQTKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:10:51 -0500
Received: from chmailsrv.int.mrv.com ([66.43.110.11]:10102 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752587AbZBQTKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:10:51 -0500
Message-ID: <499B0BBB.3020201@mrv.com>
Date: Tue, 17 Feb 2009 11:10:51 -0800
From: Nye Liu <nyet@mrv.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: modpost: Something amiss with do_hid_entry() - id->bus endianess
 wrong?
References: <20090217045840.GA28536@mrv.com> <499AA1B5.5090501@gmail.com>
In-Reply-To: <499AA1B5.5090501@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2009 19:13:12.0315 (UTC) FILETIME=[C6E6E4B0:01C99133]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Nye Liu wrote:
>   
>> i am having problems with endianness on the id->bus value in do_hid_entry().
>>
>> i think there is a "TO_NATIVE(id->bus);" missing in scripts/mod/file2alias.c:
>>     
>
> Definitely! Good spotting, thanks.
>
> Could you try the patch I posted a minute ago?
>   
Yes, it works; i posted an almost identical patch not long before you did ;)
