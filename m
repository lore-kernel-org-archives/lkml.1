Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXDEEJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXDEEJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 00:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXDEEJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 00:09:45 -0400
Received: from holomorphy.com ([66.93.40.71]:60553 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXDEEJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 00:09:45 -0400
Date: Wed, 4 Apr 2007 21:09:56 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-ID: <20070405040956.GO2986@holomorphy.com>
References: <20070404172931.GM2986@holomorphy.com> <7653.1175726207@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7653.1175726207@turing-police.cc.vt.edu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 10:29:31 PDT, William Lee Irwin III said:
>> Index: anon/include/linux/resource.h
>> ===================================================================
>> --- anon.orig/include/linux/resource.h	2007-04-04 09:57:41.239118534 0700
>> +++ anon/include/linux/resource.h	2007-04-04 09:57:59.840178548 -0700
>> @@ -18,7 +18,8 @@
>>   */
>>  #define	RUSAGE_SELF	0
>>  #define	RUSAGE_CHILDREN	(-1)
>> -#define RUSAGE_BOTH	(-2)		/* sys_wait4() uses this */
>> +#define RUSAGE_THREAD	(-2)
>> +#define RUSAGE_BOTH	(-3)		/* sys_wait4() uses this */

On Wed, Apr 04, 2007 at 06:36:47PM -0400, Valdis.Kletnieks@vt.edu wrote:
> Umm.. I'm having a high-idiot-quotient day today, but don't you want to
> leave _BOTH at -2 and put _THREAD at -3, to avoid an ABI breakage?

It's a rather natural question. The answer is that RUSAGE_BOTH is only
ever used internally to the kernel, so there is no userspace ABI change.


-- wli
