Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYJQJwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYJQJwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYJQJwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:52:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:5664 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYJQJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TxVg6ft8KrR9Cnhwl0C9HSLdGcWnVK1pqa8J+8uWz8FkC8ACqhy6pTWbCayrGFfA+m
         n16WvYOsPLymN5/NS4nRyn/4NDLit3BpDi+U2HLvoJMphu7/UgpHJC8ZKEjrMxeziGtO
         I6FStNZ2kQzyku6Rpog0/Lkf6EOOmm9plAMms=
Message-ID: <aec7e5c30810170252t5790af36hfc754d28e69f5159@mail.gmail.com>
Date: Fri, 17 Oct 2008 18:52:32 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH v3] Add SPI over GPIO driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Piot Skamruk" <piotr.skamruk@gmail.com>,
       "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <200810171052.54823.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807202146.12759.mb@bu3sch.de>
	 <aec7e5c30810162014w33fe08f2ta2b05cb187770e3a@mail.gmail.com>
	 <200810171052.54823.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removed closed openwrt-devel list]

On Fri, Oct 17, 2008 at 5:52 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 17 October 2008 05:14:26 Magnus Damm wrote:
>> On Mon, Jul 21, 2008 at 4:46 AM, Michael Buesch <mb@bu3sch.de> wrote:
>> > This adds a driver that lets you drive an SPI bus over
>> > generic GPIO pins.
>> >
>> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
>>
>> Very useful. Fits my shiny new GPIO implementation for SuperH like a glove.
>>
>> Michael, as you know, I have some SuperH board code that makes use of
>> this driver. Are there any outstanding issues with this driver that I
>> can help resolving?
>
> bool cs_activelow should probably be removed from struct spi_gpio_platform_data.
>
> I think cs always is activelow, so we can simply hardcode this in spi_gpio_chipselect()

Really? There _must_ be chips out there that want active high CS!
I'd rather keep the activelow option or maybe turn in into activehigh instead.

> If you want to do this, please feel free to do so.
> I currently don't have the time for this.
> The rest of the driver is fine with me.

Ok, thank you.

David or Andrew, any change of getting this merged as-is somehow? Thanks!

/ magnus
