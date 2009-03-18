Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZCRBYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZCRBYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 21:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZCRBXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 21:23:50 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:11174 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbZCRBXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 21:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CH9mMjHavDdvxhVHtYjdx+ZUy3xBxKnq64nXM1hgSET19K8scRfyit0iP43gfswgW0
         7JukRp37rZ+CM9UtL1kpgC24vl1S3QEV3s0q6hiU2gO5Kon+CntCvfA8/MM3ik+5x+TV
         DyabHlt/lmiM2k55wjDXiBmzkDxMBXNQlCrKw=
MIME-Version: 1.0
In-Reply-To: <20090318.094935.238694196.nemoto@toshiba-tops.co.jp>
References: <e9c3a7c20903162152w6b73b4b8hba8004e7b349c447@mail.gmail.com>
	 <20090318.010939.128619068.anemo@mba.ocn.ne.jp>
	 <e9c3a7c20903171002n50964148v8366fa2f00e3164c@mail.gmail.com>
	 <20090318.094935.238694196.nemoto@toshiba-tops.co.jp>
Date: Tue, 17 Mar 2009 18:23:46 -0700
X-Google-Sender-Auth: c02529558b46bc28
Message-ID: <e9c3a7c20903171823g1e6c42b9t5f042d550a6ddd47@mail.gmail.com>
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 5:49 PM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Tue, 17 Mar 2009 10:02:14 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> BTW, there are another holes in dma_async_device_register.  If
> idr_pre_get or idr_get_new was failed, idr_ref will not be freed.

Thanks for these fixlets, I appreciate it.

Now, back to the issue at hand.  Does your driver still need direct
control over chan->chan_id, or can it now rely on the fact that
dma_async_device_register() will fail if a channel is not initialized?
 Or, just use some platform_data to identify the channel in the same
manner as atmel-mci?

Regards,
Dan
