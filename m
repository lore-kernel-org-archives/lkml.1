Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbZGYSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbZGYSWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZGYSWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 14:22:16 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:34121 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbZGYSWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 14:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ncmG6XDL/0KRNixvUAatoFBXZl3l6XphPpML+lbxOfmH5+5k7si2Xw0nNg3wpPW6bE
         O6C5wPrpJq9APsKwcznRXv9IPSIFD9/D+69EK+P6xIJuDWimno3t+63mRLUCGWRzbSno
         si8G3SGhgj8oykD093RWTKERYWpTa0EgWPcR4=
MIME-Version: 1.0
In-Reply-To: <20090725174449.GC14062@dtor-d630.eng.vmware.com>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com>
	 <20090725174449.GC14062@dtor-d630.eng.vmware.com>
Date: Sat, 25 Jul 2009 20:15:50 +0200
Message-ID: <f861ec6f0907251115n3e1ad622uaf94c21dc4de0393@mail.gmail.com>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>, Frans Pop <elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 7:44 PM, Dmitry
Torokhov<dmitry.torokhov@gmail.com> wrote:
> Hi Manuel,
>
> On Wed, Jul 22, 2009 at 05:18:39PM +0200, Manuel Lauss wrote:
>> Cc: Frans Pop <elendil@planet.nl>
>> Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
>>
>> +
>> +static struct dev_pm_ops au1xmmc_pmops = {
>> +     .resume         = au1xmmc_resume,
>> +     .suspend        = au1xmmc_suspend,
>> +};
>> +
>
> Was suspend to disk tested? It requires freeze()/thaw().

No, only suspend-to-ram, but that's good to know.
Currently for me only STR is important (and testable),
I'll have to check wheter STD works on MIPS with my test
hardware.

Thank you!
     Manuel Lauss
