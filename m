Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYKNSPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYKNSPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYKNSPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:15:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:18156 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNSPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:15:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KNv33HSpdu8yhDEWM024jqPUZEBfgFA4CNWkcsZkUVnddS+V7YeNJAEZklExKhlo9l
         bXLJtOt/7LhxO7PQXtP/d6DvAWKZWaicYXWp+RPV59agRS5JkNArZs4J2E7KZ8s0R9Yn
         2Gx7HqlAbSl7v96O0ytOUIQMgBcIyOlFMfG2E=
Message-ID: <8bd0f97a0811141015j1bd862a3n268e522e4369a39c@mail.gmail.com>
Date: Fri, 14 Nov 2008 13:15:40 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH v2] mtd: unify mtd partition/device registration
Cc: vapier@gentoo.org, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081114.232742.128619046.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226665351-20226-1-git-send-email-vapier@gentoo.org>
	 <20081114.232742.128619046.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 09:27, Atsushi Nemoto wrote:
> On Fri, 14 Nov 2008 07:22:31 -0500, Mike Frysinger wrote:
>> Rather than having every map/mtd driver doing the same sequence of
>> registering partitions and/or devices, implement common parse_mtd().
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> v2:
>>       - ifdef parsers in parse_mtd()
>>       - add "always_whole" to parse_mtd()
>>       - add unparse_mtd()
>>
>>  drivers/mtd/mtdcore.c   |   60 +++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mtd/mtd.h |    5 ++++
>>  2 files changed, 65 insertions(+), 0 deletions(-)
>
> Though not tested yet on real hardware, all patches looks OK for me.

ive tested the various code paths with physmap on my BF548-EZKIT ...
seemed to work OK ...
-mike
