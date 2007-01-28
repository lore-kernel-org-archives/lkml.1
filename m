Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXA1HNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXA1HNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 02:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXA1HNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 02:13:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:4700 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbXA1HNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 02:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:x-accept-language:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=ey6UcrbFz2t9CB0yGSw1eLgQ3XUnEx55/a/t3bZSx/Jkrb8zddykMV+qA9vMNFVThAInsNBqpaVtSJ2l8aWmY7Tl8jxnaOgGIL0/ScoVu4M1Gqb1V8/on6z5iwDuxZ/MihDdYWIcEMJoTWg0kybISUnxadwCAxFk4Z0jkPEhGTs=
Message-ID: <45BC4CFE.7050602@googlemail.com>
Date: Sun, 28 Jan 2007 08:13:02 +0100
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: linux-omap-open-source@linux.omap.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: definite OMAP1610_IR-related typo
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote at LKML:
 > not sure what to do with this, it's all yours:
 >
 > ========== OMAP1610_IR ==========
 > ./arch/arm/mach-omap1/devices.c:#if 
defined(CONFIG_OMAP1610_IR) ||
 > defined(CONFIG_OMAP161O_IR_MODULE)
 > ========== OMAP161O_IR ==========
 > ./arch/arm/mach-omap1/devices.c:#if 
defined(CONFIG_OMAP1610_IR) ||
 > defined(CONFIG_OMAP161O_IR_MODULE)
 >
 > note first that one of those config vars has an "oh" 
while the other
 > has a *zero*. i'm pretty sure that's bad.
 >
 > in any event, there's no such config variable of *either* 
spelling
 > in any Kconfig file, but there *is* a more all-encompassing
 > CONFIG_OMAP16XX confguration setting.

This is fixed in recent OMAP git tree and OMAP patches we 
prepared for upstream. Can you try OMAP patches 4113, 4114, 
4115 and 4116 to be found in RMKs patch system [1]? Or, even 
better, use current OMAP git [2]?

Regards

Dirk

P.S. #1: Would be nice to CC OMAP list [3] next time as well.

P.S. #2: Sorry if mail references are wrong, I'm currently 
not subscribed to LKML.

[1] 
http://www.arm.linux.org.uk/developer/patches/section.php?section=0

[2] 
http://source.mvista.com/git/gitweb.cgi?p=linux-omap-2.6.git;a=summary

[3] 
http://linux.omap.com/mailman/listinfo/linux-omap-open-source


