Return-Path: <linux-kernel-owner+w=401wt.eu-S939214AbXGSQ0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939214AbXGSQ0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760729AbXGSQZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:25:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59349 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936303AbXGSQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:25:53 -0400
Date: Thu, 19 Jul 2007 18:25:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>, adobriyan@sw.ru,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert part of 3f1b0e1f287547903f11fa1e6de7d2765597766e
In-Reply-To: <20070718185211.GA5575@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0707191824480.31013@fbirervta.pbzchgretzou.qr>
References: <200707182103.13500.caglar@pardus.org.tr>
 <20070718185211.GA5575@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-765628514-1184862352=:31013"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-765628514-1184862352=:31013
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jul 18 2007 22:52, Alexey Dobriyan wrote:
>
>On Wed, Jul 18, 2007 at 09:03:13PM +0300, S.Çağlar Onur wrote:
>> With 3f1b0e1f287547903f11fa1e6de7d2765597766e Linus's current git tree starts 
>> to ignore any *.orig or *.rej files (for example "git status" cannot show 
>> what are they) but if there are some *.orig or *.rej files exists, for 
>> whatever reason, that means some unresolved merge conflicts occured for that 
>> code tree and this tree is no longer trusted so better not to ignore these.
>
>*.orig are generated even if line numbers change a bit, so untrusted is
>a somewhat exaggerated.

So use --no-backup-if-mismatch (IIRC).

>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -45,6 +45,3 @@ series
>>  
>>  # cscope files
>>  cscope.*
>> -
>> -*.orig
>> -*.rej

Ok to me.


	Jan
-- 
---699020219-765628514-1184862352=:31013--
