Return-Path: <linux-kernel-owner+w=401wt.eu-S1765733AbXGZG7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765733AbXGZG7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbXGZG65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:58:57 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:51327 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251AbXGZG64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:58:56 -0400
Message-ID: <46A845BB.9080503@gmail.com>
Date: Thu, 26 Jul 2007 08:56:59 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Bongani Hlope <bhlope@mweb.co.za>
CC: Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org
Subject: Re: updatedb
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com> <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com> <46A81C39.4050009@gmail.com> <200707260839.51407.bhlope@mweb.co.za>
In-Reply-To: <200707260839.51407.bhlope@mweb.co.za>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2007 08:39 AM, Bongani Hlope wrote:

> On Thursday 26 July 2007 05:59:53 Rene Herman wrote:

>> So what's happening? If you sit down with a copy op "top" in one terminal
>> and updatedb in another, what does it show?

> Just tested that, there's a steady increase in the useage of buff

Great. Now concentrate on the "swpd" column, as it's the only thing relevant 
here. The fact that an updatedb run fills/replaces caches is completely and 
utterly unsurprising and not something swap-prefetch helps with. The only 
thing it does is bring back stuff from _swap_.

Rene.

