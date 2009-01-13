Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZAMTU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZAMTU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZAMTUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:20:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:16112 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZAMTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HV12qJS8yMbP2aY6i7zUQ3azY7kPb8KfCOMn5eTheR6GGyTiJTZIaTBgzqpJC1Ujjd
         +mjaA8SKP/Yal430snBLGZzYdl8CTbF5P1DpbljUSqE9dtaEsxUrj408jKQ1Ze+sAqWM
         y0oyeOGRqNBUijoOCQX4HsBVStcgfx/47aAvA=
Message-ID: <e9c3a7c20901131120k82e55edl4e6d23bc71af70e3@mail.gmail.com>
Date: Tue, 13 Jan 2009 12:20:44 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] dmatest: Use custom map/unmap for destination buffer
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com
In-Reply-To: <20090113164816.7f7d3d31@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231860880-6277-1-git-send-email-anemo@mba.ocn.ne.jp>
	 <20090113164816.7f7d3d31@hskinnemoen-d830>
X-Google-Sender-Auth: 26dd1cb84cf3f469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 8:48 AM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> Atsushi Nemoto wrote:
>> The dmatest driver should use DMA_BIDIRECTIONAL on the destination buffer
>> to ensure that the poison values are written to RAM and not just written
>> to cache and discarded.
>>
>> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
>
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Applied to async_tx.git/fixes.

Thanks,
Dan
