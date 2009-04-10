Return-Path: <linux-kernel-owner+w=401wt.eu-S936799AbZDJRTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936799AbZDJRTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935382AbZDJRSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:18:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765510AbZDJRSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:18:42 -0400
Message-ID: <49DF7F2E.4050909@zytor.com>
Date: Fri, 10 Apr 2009 10:17:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz>
In-Reply-To: <20090410080444.GC16512@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
>> +/*
>> + * "Glove box" for BIOS calls.  Avoids the constant problems with BIOSes
>> + * touching memory they shouldn't be.
>> + */
> 
> Touching memory? AFAICT it only prevents touching registers.
> 

Ah yes.  -EBUGGYCOMMENT.  ;)

	-hpa

