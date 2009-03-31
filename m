Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZCaTfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZCaTfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZCaTfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:35:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:51318 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbZCaTfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xrqXYMiJmYBSIWl9LpgRjfkETTa/WdGPoxCHLvLBW5wIf87hJmwQ/JmRYZVIh6EARe
         PO00K9dTJbxU7TADxtI3Y23HTcVkZBTxjtOr70PT5LI8qJsesaC8fPYVkxw7IEFgxeSH
         73Vp3jmVxFaoyg4jWjYZ2nX2rfR8U2yjMPXuk=
MIME-Version: 1.0
In-Reply-To: <20090326.231243.112855442.anemo@mba.ocn.ne.jp>
References: <20090318.110154.76582864.nemoto@toshiba-tops.co.jp>
	 <e9c3a7c20903181026h1801ef6i945e6ce9ccb36b8a@mail.gmail.com>
	 <20090321.212920.25912728.anemo@mba.ocn.ne.jp>
	 <20090326.231243.112855442.anemo@mba.ocn.ne.jp>
Date: Tue, 31 Mar 2009 12:34:59 -0700
X-Google-Sender-Auth: ef1f37b66b6e19c6
Message-ID: <e9c3a7c20903311234t63335987l46480cd27a326022@mail.gmail.com>
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

On Thu, Mar 26, 2009 at 7:12 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Sat, 21 Mar 2009 21:29:20 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> Unfortunately, not so simple.  If I created a dma_device for each
> channel, all chan->chan_id will be 0 and all chan->device->dev points
> same platform device.  This makes client driver hard to select the
> particular channel.  Making a platform device for each channel will
> solve this, but it looks wrong way to go for me.

Why?  mv_xor, iop-adma, and ioat each have a platform or pci device
per channel so you would be in good company.
