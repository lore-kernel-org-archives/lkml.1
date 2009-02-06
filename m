Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZBFTYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZBFTYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBFTYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:24:30 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:13351 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZBFTY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SWjoVG55e/nUy5BhvhSduQECF5CwI6NCfdM7+0VV9U9QYhu8R9C2FUjx4QfPQyt4gc
         hwVgi8+/ABk9nEvoMS0x/aE03WRSKqhphjcuWJdAtkZ6QJzjHVZJ38PyGPaDdNXOWd63
         LcSo6njUPXnfwHA2Jn2nWtunhtdajrEMW/Cjc=
MIME-Version: 1.0
In-Reply-To: <20090206191558.GD10711@frodo>
References: <1233915736-18506-1-git-send-email-cooloney@kernel.org>
	 <20090206191558.GD10711@frodo>
Date: Fri, 6 Feb 2009 14:24:27 -0500
Message-ID: <8bd0f97a0902061124s3c44d39dmf306a44f0c16528d@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused 
	warnings
From: Mike Frysinger <vapier.adi@gmail.com>
To: me@felipebalbi.com
Cc: Bryan Wu <cooloney@kernel.org>, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 14:15, Felipe Balbi wrote:
> On Fri, Feb 06, 2009 at 06:22:16PM +0800, Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>
> I'd like to get a patch body here.
>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/usb/musb/blackfin.c |    9 +++++----
>>  1 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
>> index 7861348..0ebb19d 100644
>> --- a/drivers/usb/musb/blackfin.c
>> +++ b/drivers/usb/musb/blackfin.c
>> @@ -54,13 +54,11 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
>>  void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
>>  {
>>       void __iomem *fifo = hw_ep->fifo;
>> +
>> +#ifdef CONFIG_BF52x
>>       u8 epnum = hw_ep->epnum;
>>       u16 dma_reg = 0;
>
> Is this patch avoiding a warning about these variables being unused ?
>
> Would be nice to get this info to the patch body ;-)

the subject already says that
-mike
