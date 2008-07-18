Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbYGRU0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbYGRU0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYGRU0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:26:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:8795 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYGRU0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NvrWPAxTt4PzfzelGNeiXF7CYgqmeOaCPokX1H1IHMJtvUxLa9CBGLTAZTzD//MNI1
         G5DQ/ncUqNHdGghPGrb95t1Dw2HlFHsCWwKaTab/4GVzZyq9NVZfblvdOSklxep1AJJZ
         SVybKds6ZDhBQeA52R49naEdx6N1bT7PNp7PA=
Message-ID: <86802c440807181326l489b7763sdb040f5b6e575d8c@mail.gmail.com>
Date: Fri, 18 Jul 2008 13:26:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       jbarnes@virtuousgeek.org, "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080718202118.GC24122@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807180941.09779.yhlu.kernel@gmail.com>
	 <20080718202118.GC24122@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 1:21 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> change the mconf bus range from [0,0xff] to to [0, 0x3f] to match
>> range [0xf0000000, 0xf4000000) in e820 tables.
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
>
> great find!
>
> If you can think of further debug mechanisms in the kernel to make the
> fixing of similar problems easier, feel free ... The easier it is for
> users to track down such problems the better for Linux in general.
>

[PATCH] x86,pci: detect end_bus_number according to acpi/e820 reserved
is more smart to address hpa's request.

YH
