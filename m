Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbYHUOb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbYHUOb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYHUObr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:31:47 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:25346 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbYHUObp (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YDiYHLMzoh0cNxZzgkuuGoLgDsia47v7MiOmse8Rc+BgHA7fuyV2wFjFMSi1ot1s8R
         /2Je7nwjsjcxVllHXC7R4PJXqHPaM3grkqW/1hR5othsSAECsTZ9XVX1Fmg5HRmpsyWF
         9a5TcesC9JlNoFz0WQBydHDTRrruSK1TZz7gw=
Message-ID: <c384c5ea0808210731k17ccc836u60c4803c3abfea31@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:31:44 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <6934efce0808210719s6458dc77w2c0755a4bf90bf8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <20080821083916.GF5706@disturbed>
	 <6934efce0808210719s6458dc77w2c0755a4bf90bf8a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jared,

On Thu, Aug 21, 2008 at 4:19 PM, Jared Hulbert <jaredeh@gmail.com> wrote:
>> FWIW, I'm not sure it's a good idea to name this new filesystem AXFS.
>> People are almost certainly going to confuse it with XFS despite
>
People that care about their filesystem choice know their choices.
People that don't
care, well they don't care.

Maybe AXIPFS would be the close alternative.

One question on the use-case profiling and subsequent image rebuild:

What if the use-case did not cover all cases of XIP use?

If a compressed page is attempted to be executed, will the filesystem
fall back to decompression to RAM and execution from RAM, or will this
result in a faulty system?

The design choices look real good. Congrats on the achievement.

Regards,
-- 
Leon
