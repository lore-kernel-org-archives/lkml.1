Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbXH3Ebs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbXH3Ebs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 00:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXH3Ebj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 00:31:39 -0400
Received: from [212.12.190.141] ([212.12.190.141]:32967 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752336AbXH3Ebi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 00:31:38 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
Date: Thu, 30 Aug 2007 07:31:20 +0300
User-Agent: KMail/1.5
Cc: dex@dragonslave.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708300731.20336.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Daniel Exner <dex@dragonslave.de> wrote:
>> Attached patch will add above mentioned Laptop Model to whitelist for both 
>> pata_ali and alim15x3, as it is correctly detected as 40-wire connected
>> but this cable is short enough to still do transfers higher than UDMA33.
>
> Looks good to me - does need a Signed-off-by: line however

Wow!  I have been running 80wire cable detection override on 40wire cables 
for quite some time without any problem, but I never thought it to be legal 
if the 40wire cable length is short enough.

How short does it have to be, and can't we have a kernel bootparm to override 
the cable detection?


Thanks!

--
Al

