Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbYGDRS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbYGDRS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYGDRSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:18:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:45367 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYGDRSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oJD5A3sKu/m/hdd4pDrCSiOpRlNzDBuQoLFEKVTIHLBQ3NzJj+Fgxccw4XUfxjIgvU
         fhP3ncfAVJoYZ1EU7zXK7sJ8/oGYrDFJZ+B4Z2ubNHuG/yMeetDMN/6boN+cOib60rgz
         ntJq1QVoGWFyTrRLTqGrbazX0TZVMDRwXR0FE=
Message-ID: <961aa3350807041018p437a2d60ka5936758bf7573d5@mail.gmail.com>
Date: Sat, 5 Jul 2008 02:18:49 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH -mm] fix ipr-use-memory_read_from_buffer.patch
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Brian King" <brking@us.ibm.com>
In-Reply-To: <1215191136.5413.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807040647.m646lXpN017508@imap1.linux-foundation.org>
	 <1215182555.5413.8.camel@localhost.localdomain>
	 <20080704163942.GA15214@localhost.localdomain>
	 <20080704165438.GD22477@localhost.localdomain>
	 <1215191136.5413.13.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- 2.6-mm.orig/drivers/scsi/ipr.c
>> +++ 2.6-mm/drivers/scsi/ipr.c
>> @@ -71,6 +71,7 @@
>>  #include <linux/module.h>
>>  #include <linux/moduleparam.h>
>>  #include <linux/libata.h>
>> +#include <linux/string.h>
>>  #include <asm/io.h>
>>  #include <asm/irq.h>
>>  #include <asm/processor.h>
>
> This isn't really necessary, is it?  As you can see from the file being
> stuffed full of memcpy directives, it's already getting an implicit
> include of string.h from somewhere (like the rest of the SCSI drivers).

Indeed. This is not necessary.
