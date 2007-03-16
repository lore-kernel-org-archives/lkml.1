Return-Path: <linux-kernel-owner+w=401wt.eu-S965373AbXCPOpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373AbXCPOpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXCPOpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:45:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:50870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965336AbXCPOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:45:17 -0400
From: Christian <christiand59@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
Date: Fri, 16 Mar 2007 15:44:56 +0100
User-Agent: KMail/1.9.6
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <45FAA211.5030402@shaw.ca>
In-Reply-To: <45FAA211.5030402@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161544.59430.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX19GkGjlc/8g/2tEzWD0NeFqla3js7SycplKkrQ
 s9JgDymmr1g56+zR6EBEKp4aS400f8XS/68z4ZPxK/oJB4wOGh
 xA9mf8aOgoIEXYLqsjj4Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This does indeed look like a drive side issue to me (the controller is
> reporting CPBs with response flags 2 which as far as I can tell
> indicates it's still waiting for the drive to complete the request).

I have been using this hw-config (SATA II, NCQ) since the nvidia ADMA support 
made it in the -mm kernel (maybe around 2.6.19-mm? or even earlyer). I'm 
seeing this problem excessively since I upgraded to 2.6.21-rc3-mm1. I think 
something got broken recently...

-Christian
