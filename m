Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbYDTMDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbYDTMDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYDTMC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:02:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:64342 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYDTMCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LMewsoILA+j4Z4YcgIKrxXxzv63DSDDd8hvMcCDUL9b5ynY0QTyRiXb/mcKjh2vuO7bj6/54yHNHjF6bt3H5hkHr70NkhGCNhpGchn+xQ3fANeCcyHqChZHopUa8CYQvDvWc2+i/tGdAms5NdN56nrgKCXCPrfkJRBTIq1mNR2M=
Message-ID: <e85b9d30804200502p25842ec2i712da9e388c08e87@mail.gmail.com>
Date: Sun, 20 Apr 2008 14:02:50 +0200
From: Matthew <jackdachef@gmail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Linux 2.6.25
Cc: torvalds@linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Gene Heskett" <gene.heskett@gmail.com>, "Len Brown" <lenb@kernel.org>
In-Reply-To: <e85b9d30804190322o703d3b20se22eb6b5e82bae39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Disposition: inline
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
	 <alpine.LFD.1.00.0804180843150.2879@woody.linux-foundation.org>
	 <20080418193802.GK7674@cvg> <20080418200338.GL7674@cvg>
	 <48096179.4060803@keyaccess.nl> <480964F7.3040701@keyaccess.nl>
	 <20080419061701.GA7688@cvg>
	 <e85b9d30804190318u74e14f0ct6ab53cb86f6ce15f@mail.gmail.com>
	 <e85b9d30804190322o703d3b20se22eb6b5e82bae39@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3KC3cEB000889

>  sure, I'll test-drive the vanilla-kernel, too>>  thanks
ok, tested the vanilla-kernel this morning and it shows the exact hightemperatures (with CONFIG_THERMAL=y)
I've got a question:
when trying to disable thermal it just sits there & won't change:<*> Hardware Monitoring support  --->  -*- Generic Thermal sysfs driver  --->
it seemingly depends on other things:Selected by: ACPI_THERMAL && !X86_VOYAGER && ACPI && ACPI_PROCESSOR
is it safe to disable acpi_processor and acpi or CONFIG_THERMAL ingeneral ? or will it burn down my box ? ;)
I'm asking this because it says/writes:CONFIG_ACPI_THERMAL:                                                                                                                                  This driver adds support for ACPI thermal zones.  Most mobile and          some desktop systems support ACPI thermal zones.  It is HIGHLY             recommended that this option be enabled, as your processor(s)              may be damaged without it.

thanks
Matÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
