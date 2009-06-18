Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZFRHOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZFRHOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZFRHNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:13:53 -0400
Received: from smtprelay08.ispgateway.de ([80.67.31.42]:50939 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFRHNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:13:52 -0400
References: <20090604211103.4214303f.peter@piie.net> <cone.1245086149.988051.6046.1000@deskpiie> <20090616060107.GA4752@liondog.tnic> <200906160747.04094.edt@aei.ca> <20090616205747.GA6356@rhlx01.hs-esslingen.de> <20090617001435.e2d86780.peter@piie.net> <20090617122022.GA13141@rhlx01.hs-esslingen.de>
Message-ID: <cone.1245309039.632882.31537.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Andreas Mohr <andi@lisas.de>
Cc: Ed Tomlinson <edt@aei.ca>, Borislav Petkov <petkovbb@googlemail.com>,
       akpm@linux-foundation.org, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Date: Thu, 18 Jun 2009 09:10:39 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas, Hi Boris,

Andreas Mohr writes:

>> o suspend stops and resume starts the kernelmode in a clean way
> 
> Didn't someone argue that pre_suspend_kernelmode was unnecessary?
> It's still in there. (could be submitted together with the
> Kconfig ACPI depends ;)

Actually I think pre_suspend_kernelmode is needed, so it won't be dropped.

I'll add the ACPI dependency to Kconfig and submit the patch to lkml and 
directly to Linus, as Len doesn't seem to react?! - Boris what do you think? 

I mean, even if there's a problem with suspend / resume, this can also be 
fixed after the merge window, while all those release candidates are 
done.

cheers,
--peter
