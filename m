Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbYHYUI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbYHYUI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYHYUIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:08:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:28308 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYHYUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kWJJeLZCq4wEBGBLLSjhN6YnPG+K1BfNpU3TAXgVkxo9Nj0WDDBSmVDxCQQQmr6fBm
         j+ZjC0zEPQJNS5sYlcMi+EvdSA5HuKAgsWmoB+Nzwy92NtTBTR6c3NIsv1DEGule7daP
         4QdZo/w+Zxkv6ce9ESnbQfizhUlOvlwCsfY4w=
Message-ID: <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>
Date: Mon, 25 Aug 2008 13:08:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
Cc: "Alexander Huemer" <alexander.huemer@sbg.ac.at>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <48B29320.5070903@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at> <489B85A3.7030500@sbg.ac.at>
	 <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>
	 <48A43CB5.8010709@sbg.ac.at>
	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>
	 <48AD8125.7050104@sbg.ac.at>
	 <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>
	 <48AE90BB.5090800@aitel.hist.no>
	 <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>
	 <48B29320.5070903@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 4:10 AM, Helge Hafting
<helge.hafting@aitel.hist.no> wrote:
> Yinghai Lu wrote:
>>
>> On Fri, Aug 22, 2008 at 3:11 AM, Helge Hafting
>>
>
> [old bug report removed]
>>
>> please boot with "mtrr_spare_reg_nr=3 debug"
>>
>
> I did that, and got:
> dmesg:
> Command line: root=/dev/sda2 ro mtrr_spare_reg=3 debug

please use "mtrr_spare_reg_nr=3 debug"

you missed _nr.

YH
