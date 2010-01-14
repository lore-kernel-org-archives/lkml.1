Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361Ab0ANWdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0ANWdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726Ab0ANWdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:33:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:65080 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab0ANWdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:33:05 -0500
Message-ID: <4B4F9B78.2060505@windriver.com>
Date: Thu, 14 Jan 2010 16:32:24 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 22/40] mips,kgdb: kdb low level trap catch and stack trace
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com> <1263481176-1897-23-git-send-email-jason.wessel@windriver.com> <4B4F548B.7090405@caviumnetworks.com>
In-Reply-To: <4B4F548B.7090405@caviumnetworks.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2010 22:32:33.0027 (UTC) FILETIME=[76C5F530:01CA9569]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> [...]
>   
>> +#include "../../../kernel/debug/kdb/kdb_private.h"
>>  
>>     
>
> There must be a better way of referring to this include file.  Perhaps 
> it should be moved to a more central place that is already in the 
> include path so we can refer to it with #include <.../file.h>
>   

I removed the need to include kdb_private.h.  The fix will appear in the
kgdb-next branch in the next few days.

Thanks,
Jason.
