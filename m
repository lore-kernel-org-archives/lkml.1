Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbXLVBPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbXLVBPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbXLVBPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:15:25 -0500
Received: from ns.suse.de ([195.135.220.2]:38771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbXLVBPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:15:25 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: devzero@web.de, linux-kernel@vger.kernel.org, Matt.Domsch@dell.com
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
From: Andi Kleen <andi@firstfloor.org>
References: <49015158@web.de> <47656B9E.3040405@zytor.com>
Date: Sat, 22 Dec 2007 02:15:23 +0100
In-Reply-To: <47656B9E.3040405@zytor.com> (H. Peter Anvin's message of "Sun\, 16 Dec 2007 10\:17\:02 -0800")
Message-ID: <p73sl1vedhw.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> devzero@web.de wrote:
>>         /* Query EDD information */
>>  #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
>> -       query_edd();
>> +        printf("Probing EDD (query Bios for boot-device information)\n");
>> +        printf("If boot hangs here, you may have a buggy Bios. Try edd=skipmbr or edd=off");
>> +        query_edd();
>> +        printf("\rOK                                                                       \n");
>>  #endif
>
> This is awfully verbose.

But useful. On the other hand we have lots of IMNSHO
quite useless printks in early bootup that could be removed
to make up for that

(e.g. candidates would be the 
"CPU: After/before generic identify"
or 
Entering add_active_range....) 

printks and you can easily make up for the added verbosity.

-Andi


