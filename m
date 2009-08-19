Return-Path: <linux-kernel-owner+w=401wt.eu-S1750997AbZHSDbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbZHSDbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZHSDbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:31:38 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:51845 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZHSDbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pm3IiMeall91soSufIyISoOwDZV0RVoGmrr5VkrkjvNekYZvD20GxldtrY3hff/PGR
         rOZi4+9KxEblGasgBO68fqe+tpXvyvdg4no5h7pVZXOUUGn0ra4aZb4ofcGgunIP9yPi
         PZDlQLeWwtERfRYfMQorZbllQpgUuU4vyPWlI=
MIME-Version: 1.0
In-Reply-To: <1250633438.7335.1146.camel@nimitz>
References: <alpine.LFD.2.00.0908172333410.32114@casper.infradead.org>
	 <1250633438.7335.1146.camel@nimitz>
Date: Wed, 19 Aug 2009 15:31:39 +1200
Message-ID: <202cde0e0908182031r7068416amfb1cd48f4e91ddc4@mail.gmail.com>
Subject: Re: [PATCH 2/3]HTLB mapping for drivers. Hstate for files with 
	hugetlb mapping(take 2)
From: Alexey Korolev <akorolex@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Alexey Korolev <akorolev@infradead.org>, mel@csn.ul.ie, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  #ifdef CONFIG_HUGETLBFS
>> +
>> +/* some random number */
>> +#define HUGETLBFS_MAGIC        0x958458f6
>
> Doesn't this belong in include/linux/magic.h?
>
> -- Dave
>
Right. Thank you! Will be corrected.
