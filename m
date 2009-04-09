Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbZDIJyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbZDIJyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759446AbZDIJyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:54:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:61587 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765000AbZDIJyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ngqig4jn9YY7TwSfXFagrw3BNEPiUjvfUZq1VvkPYEtfI5vCdw+UNH8ivHfGoLMSX0
         WOnj31YDQ1K5V3shEFoK4c+XiromPA6CMysPCO6L7PHuA3SHu05PS3vZ1dsQNL8GLEib
         KsdUEaRnyDnKLAX5mri9z4q4raJMwK3WEn6UE=
Message-ID: <49DDC5BF.8070205@tuffmail.co.uk>
Date: Thu, 09 Apr 2009 10:54:07 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: usb-storage@lists.one-eyed-alien.net,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: usual_tables: module license 'unspecified' taints kernel.
References: <Pine.LNX.4.44L0.0904081829050.3138-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0904081829050.3138-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 8 Apr 2009, Alan Jenkins wrote:
>
>   
>> Hi, I see this regression in v2.6.30-rc1.  I end up with a module 
>> "usual_tables.ko", which is loaded on boot and causes the kernel to 
>> complain about an unspecified license.  See subject for the exact error 
>> message.
>>
>> I have
>>
>> CONFIG_USB_STORAGE=m
>> CONFIG_USB_LIBUSUAL=y
>>     
>
> This looks like a mistake in the Makefile.  Does the patch below fix
> the problem?
>
> Alan Stern
>   

Yes.  Thanks!
