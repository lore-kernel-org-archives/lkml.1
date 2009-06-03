Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZFCCLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZFCCLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZFCCLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:11:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:55957 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZFCCLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WL34l1k41sa/nG3XHZdBENR9/bYPrk401256/YM+RT7Nqf7lTdfLS04mACkc/BDNi0
         ltgqQRveYE4GX18Zj8gKC7t42gG1BlWA/Wuka50a9vrXgPxvePg2uL0E88GiD+QRVBkU
         RpWOh9ka0SSu4rGF2v1G9rbXtN8Zja7de82TA=
MIME-Version: 1.0
In-Reply-To: <1243992286.9076.5.camel@rzhang-dt>
References: <dd18b0c30906021102h43b8ecc4u9e67687de129bca1@mail.gmail.com>
	 <1243992286.9076.5.camel@rzhang-dt>
Date: Tue, 2 Jun 2009 19:11:41 -0700
Message-ID: <dd18b0c30906021911u4c2359daje01b0477a6bd23ff@mail.gmail.com>
Subject: Re: ACPI Exception (evregion-0422): AE_ERROR, Returned by Handler for 
	[PCI_Config] [20090320]
From: Justin Mattock <justinmattock@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 6:24 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> On Wed, 2009-06-03 at 02:02 +0800, Justin Mattock wrote:
>> I posted this error a few weeks ago, but had no response.
>> So after a few weeks of looking at this, I wanted to find out if
>> this is safe to see this, or should I be concerned:
>>
>> [    5.868418] ACPI: Power Button [PWRB]
>> [    5.868547] input: Sleep Button as
>> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
>> [    5.868621] ACPI: Sleep Button [SLPB]
>> [    6.093547] ACPI Exception (evregion-0422): AE_ERROR, Returned by
>> Handler for [PCI_Config] [20090320]
>> [    6.093555] ACPI Error (psparse-0537): Method parse/execution
>> failed [\_SB_.PCI0.RP01.GFX0._PS0] (Node f703dcc0), AE_ERROR
>> [    6.093614] ACPI: Transitioning device [GFX0] to D0
>>
>> I did do a dsdt dump, and looked for any errors
>> but none had shown up.
>> kernels that I have seen this are 2.6.29 -
>> 2.6.30-rc5
>>
> please file a new bug report at
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
> and attach the full dmesg output and acpidump there.
>
> thanks,
> rui
>
>

alright(Ill have to do that when I get a chance)
As for the error message after looking into it more today
I notice this message fired off as soon as I compiled
and loaded the nvidia module.


-- 
Justin P. Mattock
