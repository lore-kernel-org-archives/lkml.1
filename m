Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbXJDSRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbXJDSRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbXJDSRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:17:25 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:45565 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbXJDSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:17:24 -0400
X-Greylist: delayed 1786 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 14:17:24 EDT
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <4705272D.7050801@avtrex.com>
Date: Thu, 04 Oct 2007 10:47:25 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Steven J. Hill" <sjhill@realitydiluted.com>
Cc: veerasena reddy <veerasena_b@yahoo.co.in>,
       linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unresoved symbol _gp_disp
References: <230962.51223.qm@web8408.mail.in.yahoo.com> <20071004173928.GA32033@real.realitydiluted.com>
In-Reply-To: <20071004173928.GA32033@real.realitydiluted.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Oct 2007 17:47:26.0092 (UTC) FILETIME=[A02514C0:01C806AE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Hill wrote:
>> I have written a loadble module ( which gets complied
>> along with kernel) which does some floating point
>> operation.
>>  
> NO FLOATING POINT in the kernel PERIOD.

Unless you compile your code with -msoft-float *and* also have a version 
of libgcc compiled with -mlong-calls -mno-abicalls -G0.  If you do it 
that way, floating point works fine in the kernel (as long as you don't 
try to call sprintf with floating point parameters).


> Either use integer
> operations, or redo your software architecture and do the
> floating point in userspace.
> 
> -Steve
> 

