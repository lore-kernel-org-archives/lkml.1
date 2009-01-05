Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZAEWbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZAEWbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZAEWa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:30:59 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:50075 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZAEWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:30:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=D56Fe2qN18Nrlux/8Hd2pamMdmz8b9DpQDH4SdsyvDO1Dc+Lx3YxyhABNJZxJ+igdg
         REMVwxC4bxqMLRd//+vqOtReSweUuQZ9wSl1dtJtln6Y5I1vmO+N+3zWQHz1M0vUTgym
         8EbOEuQCArY8Ba253FyYjlJ00f7oU3NRNK7eU=
Message-ID: <49628A1E.9080003@gmail.com>
Date: Mon, 05 Jan 2009 23:30:54 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, weidong.han@intel.com
Subject: Re: mmotm 2009-01-05-12-50 uploaded
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
In-Reply-To: <200901052050.n05Kox9j012519@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2009 09:50 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-05-12-50 has been uploaded

Hi,

it fails to build here due to this link error:
drivers/built-in.o: In function `alloc_iommu':
(.text+0xf1bf): undefined reference to `iommu_calculate_agaw'

CONFIG_INTR_REMAP "depends" now on CONFIG_DMAR. Could you fix it, Weidong Han?

regards,
--js
