Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZKPWJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZKPWJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZKPWJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:09:33 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36495 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbZKPWJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:09:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pwOXysA+WkKVQkzFh+pKjZ4RUdY34VuY4E4ocNGlYJBAcrXEZEz7lJUiFyw0auIo0i
         ILfoyEsCNvyDKx22dcwExXE6dq2ptiDWyDOPqy90eZ+iRid3alXOm+PFTw8XtusOKHff
         nsMnH1hdmuRFaZWVgcTOl84OSnGHqyNrleVBs=
Message-ID: <4B01CD9D.7040601@lwfinger.net>
Date: Mon, 16 Nov 2009 16:09:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8187se: Rename staging driver to avoid name
 	conflict with mainline driver
References: <4b016848.3j3kclbqZ4ylyZGU%Larry.Finger@lwfinger.net> <69e28c910911161202w5255bff5ydb7fc665b3320bda@mail.gmail.com>
In-Reply-To: <69e28c910911161202w5255bff5ydb7fc665b3320bda@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2009 02:02 PM, Gábor Stefanik wrote:
>>
>> -obj-$(CONFIG_RTL8187SE)        += rtl8187se.o
>> +obj-$(CONFIG_RTL8187SE_STAGE)  += rtl8187se_stage.o
> 
> Please make this r8187se.o, to be consistent with the other
> r8180-sa2400 derivative drivers.

I cannot do that. From what I see, the kernel make system creates the .ko file
from the name specified here. When I make that rtl8187se.o, then I get
rtl8187se.ko, which is what I want to avoid.

Larry
