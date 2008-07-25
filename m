Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbYGYCPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbYGYCPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYGYCOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:14:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:50773 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYGYCOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Eh+MLnVBvVn62VgdIZpcWFhN+Sbtn5ep968jlE6WwxZ3JAUxtCRzzEQh3HLOFL83k0
         e5TU2L/61bS8yTUkAgANHhL2fqpGlht+PeOMVSaI138Hp3RSSELVPxtVmKLXB7wX/qTy
         YxdF/OUCA7C6O4yNdnQqPLP/XZE9Q3mOEJu+o=
Message-ID: <86802c440807241914o3e09a1a2la1cf9345b4b0e52b@mail.gmail.com>
Date: Thu, 24 Jul 2008 19:14:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Brownell" <david-b@pacbell.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH] usb: move ehci reg def
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <200807241757.23441.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807231252.20371.yhlu.kernel@gmail.com>
	 <200807231739.39620.yhlu.kernel@gmail.com>
	 <200807241727.57692.yhlu.kernel@gmail.com>
	 <200807241757.23441.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 5:57 PM, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 24 July 2008, Yinghai Lu wrote:
>>
>> prepare x86: usb debug port early console
>>
>> move ehci struct def to linux/usrb/ehci_def.h from host/ehci.h
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
>
> so long as the minor issue below is fixed:
>
>
>>
>>       ...
>> +#include <linux/usb/ehci_def.h>
>>
>>  /*-------------------------------------------------------------------------*/
>>
>> +
>
> Only one blank line needed please.  ;)

thanks.
Greg, Do i need to resend ?

YH
