Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZKDObe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZKDObe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZKDObe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:31:34 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:41891 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbZKDObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:31:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Y5t1c0Z/CpRuq9Ec2aDlgNT8XuVtew+PCPrXcTrr7V5nv4/ZthCsz0GhODh6+7paG2
         0muvTWIh1PO6yIk/Z6Y/fVp5J+7lLf+dfLi4sOS1bCAGFXZzRf+nf6E12IzVf1SZmwzk
         EElL7wWmO1D8iKfK6dbaoXdLFeMHBMpJIybdo=
Date: Wed, 4 Nov 2009 22:31:27 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200911042011027500109@gmail.com>
Subject: Re: Re: [PATCH]kernel/irq/chip.c:Modify the code note
Message-ID: <200911042231252503000@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nA4EVp16023932

Thank you very much.

Someone tell me that my pre-mail's format is incorrect. The correct format is
......
Changlog
......
Signed-off-by: yourname <your@mail>
----------------------
patch context

And I have not received your mail. Maybe The gmail play a trick.

Then, I re-submitt this hunk after a week.

But now, I have found your mail in the mail-list.



  


2009-11-04 



Liuweni 



·¢¼şÈË£º Jiri Kosina 
·¢ËÍÊ±¼ä£º 2009-11-04  21:06:24 
ÊÕ¼şÈË£º Liuweni 
³­ËÍ£º linux-kernel; qingshenlwy; xgr178 
Ö÷Ìâ£º Re: [PATCH]kernel/irq/chip.c:Modify the code note 
 
On Wed, 4 Nov 2009, Liuweni wrote:
> In the origin, the code notes are not fit for set_irq_msi. 
> The function name is set_irq_data.
> 
> And, I change function note "handle_percpu_IRQ" to "handle_percpu_irq".
> 
> 
> Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
> 
> ------------------------------------------
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index c166019..ba566c2 100644
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
You have submitted this hunk separately before, and I already have it in 
my queue (and I have sent you a mail informing you about this being 
merged), so you'd better not include it as part of any further patch 
submissions.
-- 
Jiri Kosina
SUSE Labs, Novell Inc.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
