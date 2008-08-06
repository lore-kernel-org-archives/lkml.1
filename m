Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbYHFIdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbYHFIdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYHFIdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:33:41 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:45555 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYHFIdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kvMNIprrPAhbG1Zfr1PQ9jy1tYNUsJrJ2VWuteLWyS79En+PFz/AF8DfKfiD3uxoKU
         UTKpJFZDxmqmvt1L0V24BoPc+nIm+9uojtSEZBIAWC0s5axzxcs8MEgKVHOgG3CpzgbZ
         GCqq7L+OSox77/KtHPGkZE1Cpvwv3p+X1H4wY=
Message-ID: <489961B9.6010207@gmail.com>
Date: Wed, 06 Aug 2008 17:32:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Michael Brennan <brennan.brisad@gmail.com>, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, matthew@wil.cx, jeff@garzik.org
Subject: Re: Waking up from suspend regression
References: <200808060325.54537.brennan.brisad@gmail.com> <20080806083129.GC20055@kernel.dk>
In-Reply-To: <20080806083129.GC20055@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Aug 06 2008, Michael Brennan wrote:
>> Hi,
>>
>> I am having some major problems with the newest kernels on my Thinkpad R61i 
>> and I'm doing my best trying to debug the problems.
>>
>> One problem is waking up from suspend to RAM. Earlier kernels worked fine 
>> (e.g. 2.6.25), but with the latest the system is unusable after waking up.
>> When trying to wake the computer up it first is completely unresponsive with a 
>> black screen. After about 40 seconds it comes back alive and shows the locked 
>> screensaver. But whatever I do I just get error messages, trying to unlock 
>> the screen, it says authentication failed for some reason. If I try to log in 
>> from console I just get kernel messages about I/O errors from the SATA HDD.
>>
>> I have bisected this and get this behavior after the patch: 
>> [ce6fce4295ba727b36fdc73040e444bd1aae64cd] PCI MSI: Don't disable MSIs if the 
>> mask bit isn't supported
> 
> Same here, sata is dead after the resume. Thinkpad X60.
> 

Known bug && patch available.

http://bugzilla.kernel.org/show_bug.cgi?id=11178

-- 
tejun
