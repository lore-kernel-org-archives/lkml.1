Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZBKMC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZBKMC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZBKMCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:02:19 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:58583 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZBKMCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=srZnUsOLybXlW1RZ6sSDOupEkK0y/TdbCNipVUWvwwqSqQSXNVFQFqYT92x0WSfqq5
         JuCpqOQHbB0N8q9tsLMA9ELQ//tFZGVgoGTLd8ELDqxQDma/rWiCtComv4UazsUvDikI
         btvRYYxkCk7gxC4NjHEC5JEfalphBEr/s7kpg=
MIME-Version: 1.0
In-Reply-To: <4992A7C1.7040607@tremplin-utc.net>
References: <200902102347.n1ANlYkI011003@imap1.linux-foundation.org>
	 <4992A7C1.7040607@tremplin-utc.net>
Date: Wed, 11 Feb 2009 13:02:16 +0100
Message-ID: <cb7bb73a0902110402o58816f56qb6b7ee200ca24c2e@mail.gmail.com>
Subject: Re: lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch 
	removed from -mm tree
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: akpm@linux-foundation.org, palatis@gmail.com, pavel@suse.cz,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 11:26 AM, Éric Piel <eric.piel@tremplin-utc.net> wrote:
> akpm@linux-foundation.org schreef:
>> The patch titled
>>      lis3lv02d: add axes knowledge of HP Pavilion dv5 models
>> has been removed from the -mm tree.  Its filename was
>>      lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch
>>
>> This patch was dropped because an updated version will be merged
>
> Hello Andrew,
> With the patch "lis3lv02d: support both one- and two-byte sensors",
> Giuseppe has confirmed that this patch is still correct. Would you mind
> queuing it back for 2.6.29?
>
> Palatis, if you could try this patch plus the patch "lis3lv02d: support
> both one- and two-byte sensors" to confirm it does the right thing also
> with your laptop, it would be great. Unfortunately, right now I think
> they apply only on top of the -mm tree...

It's possible to apply them on top of Linus' tree modulo Pavel's
"don't touch init" patch.

However, I think my patch might not be good for Palatis. If the
dmidecode that was posted some time earlier was his (don't recall
right now) I remember it being an AMD board, whereas I'm on an Intel
board, so we have different dv5 models and we probably need different
fixes, so I need to work out a better patch, but I'll need Palatis'
help testing it.

-- 
Giuseppe "Oblomov" Bilotta
