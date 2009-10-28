Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZJ1NTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZJ1NTC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZJ1NTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:19:01 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:55323 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZJ1NTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=t8QmJgKOIysLvzIzgQ9XeGjfKLzIm069N8kPDwE1rubkWjPdD76cDeV33KIOIA/x+o
         5t3OyjQdN8PVv0vhLKP+vM7hW+xp47cqgC7e1OZ0c3LSJBtoNs8UktCatBvwLM4T8NCV
         kcf2EjoYCYneKGU4nbr3NCAsjdqh1JhV+36Ns=
Date: Wed, 28 Oct 2009 21:18:59 +0800
From: "=?utf-8?B?TGl1d2VuaQ==?=" <qingshenlwy@gmail.com>
To: "=?utf-8?B?SmlyaSBLb3NpbmE=?=" <jkosina@suse.cz>
Cc: "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
References: <b3657a100910260622w37cc2ab6nc0b52ce6e1a19f37@mail.gmail.com>
Subject: =?utf-8?B?UmU6IFJlOiBbUEFUQ0hda2VybmVsL2lycS9jaGlwLmM6VGhlIGNvZGUgbm90ZXMgaXMgbm90IGZpdCBmb3IgdGhlZnVuY3Rpb24u?=
Message-ID: <200910282118548280083@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9SDJN16031422

hi Jiri Kosina,

Thanks for your help. This is my first upload my patch.

I had repatched it to Linux kernel with Signed-off-by.
http://lkml.org/lkml/2009/10/28/12



Any problem, please let me kown. 

2009-10-28 

Best Regards
 
Liuweni
 



å‘ä»¶äººï¼š Jiri Kosina 
å‘é€æ—¶é—´ï¼š 2009-10-27  20:53:43 
æ”¶ä»¶äººï¼š liu weni 
æŠ„é€ï¼š linux-kernel 
ä¸»é¢˜ï¼š Re: [PATCH]kernel/irq/chip.c:The code notes is not fit for thefunction. 
 
On Mon, 26 Oct 2009, liu weni wrote:
> In the origin, the code notes are not fit for set_irq_msi.
> I modify the code notes, and no any changes for the code.
> 
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index c166019..da2f254 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -166,11 +166,11 @@ int set_irq_data(unsigned int irq, void *data)
>  EXPORT_SYMBOL(set_irq_data);
> 
>  /**
> - * set_irq_data - set irq type data for an irq
> + * set_irq_msi - set MSI descriptor data for an irq
>   * @irq: Interrupt number
>   * @entry: Pointer to MSI descriptor data
>   *
> - * Set the hardware irq controller data for an irq
> + * Set the MSI descriptor entry for an irq
>   */
>  int set_irq_msi(unsigned int irq, struct msi_desc *entry)
>  {
Please send the patch with proper Signed-off-by: line so that I can queue 
it in my tree.
Thanks,
-- 
Jiri Kosina
SUSE Labs, Novell Inc.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
