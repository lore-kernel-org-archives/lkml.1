Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZJLD7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZJLD7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZJLD7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:59:20 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:48060 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbZJLD7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kE9iCzbKQF/tjZ86vPMj+sOoyUbXs09hLerl62K/DaJexG3zhx/qjRY9qyskFvvvrh
         MsK8ucRy9Ndj7EbjL3LGKil9LvmGzhKaHv0/ThOU/a6hlNdM0e1DNQz8P66D0CGzyfxw
         CLltWHah/4Xt3rfsvFpPQm+ev/jQ7kw8YKv5g=
Message-ID: <4AD2A97A.3020909@gmail.com>
Date: Sun, 11 Oct 2009 20:58:50 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14379] ACPI Warning for _SB_.BAT0._BIF: Converted Buffer
 to 	expected String
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>	 <r-4Wjt4coy.A.ZrC.Ual0KB@chimera>	 <dd18b0c30910112014m4bfdc238j542864bb9f1e8161@mail.gmail.com> <1255318556.11664.11.camel@minggr.sh.intel.com>
In-Reply-To: <1255318556.11664.11.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin Ming wrote:
> On Mon, 2009-10-12 at 11:14 +0800, Justin Mattock wrote:
>    
>> On Sun, Oct 11, 2009 at 3:22 PM, Rafael J. Wysocki<rjw@sisk.pl>  wrote:
>>      
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.31.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14379
>>> Subject         : ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
>>> Submitter       : Justin Mattock<justinmattock@gmail.com>
>>> Date            : 2009-10-08 21:46 (4 days old)
>>> References      : http://marc.info/?l=linux-kernel&m=125504031328941&w=4
>>>
>>>
>>>
>>>        
>> pulled rc4 today and the warning is still present.
>> here is the results of git bisect:
>>      
>
> Patch at http://bugzilla.kernel.org/show_bug.cgi?id=14379#c1 fixes the
> warning.
>
> Actually, the _BIF warning was fixed at commit
> e899b6485c332aa2d7510739507ab5e5d7b28e59.
> See http://bugzilla.kernel.org/show_bug.cgi?id=11822#c14
>
> I made a mistake at the cleanup of predefined method table so the
> warning shows up again.
>
> Lin Ming
>
>    
Cool, I can give that a try.
then I guess just leave this open(bugreport) until this patch
http://bugzilla.kernel.org/show_bug.cgi?id=14379#c1
gets pushed into the main tree then close the bugreport.

Justin P. Mattock
