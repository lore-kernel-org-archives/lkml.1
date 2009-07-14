Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZGNHHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZGNHHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZGNHHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:07:24 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.45]:38676 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZGNHHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:07:23 -0400
References: <20090712232104.4f2fbf46.peter@piie.net> <20090713160614.521c932a.akpm@linux-foundation.org>
Message-ID: <cone.1247555228.809275.18208.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, andi@lisas.de,
       petkovbb@googlemail.com
Subject: Re: [PATCH] Acerhdf: fix fan control for AOA150 model
Date: Tue, 14 Jul 2009 09:07:08 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton writes:

> On Sun, 12 Jul 2009 23:21:04 +0200
> Peter Feuerer <peter@piie.net> wrote:
…
>> Changed:
>>  o Applied Borislav Petkov's patch (convert the fancmd[] array to a real 
>>    struct thus disambiguating command handling and making code more readable.)
>>  o Added BIOS product to BIOS table as AOA110 and AOA150 have
>>    different register values
>>  o Added force_product parameter to allow forcing different
>>    product
>>  o fixed linker warning caused by "acerhdf_drv" not being named
>>    "acerhdf_driver"
>> 
>> Signed-off-by: Peter Feuerer <peter@piie.net>
> 
> It looks like this work should have been presented as four separate patches.

I'm not that familiar with git in general and sending patches yet. How do 
you do this in an effective way? Diffing all changes via git and then 
splitting up the "all-in-one-patch" to four smaller patches manually?
 
> Inclusion of Borislav's Signed-off-by: would be appropriate.

I wasn't sure whether I'm allowed to send the patch with his signed-off, as 
there were other things in the patch, he didn't review. But next time I'll 
send such a patch splitted up and then it's clear.

Thanks for your honesty,
kind regards,
--peter

