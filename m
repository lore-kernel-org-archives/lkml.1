Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYGICen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYGICen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 22:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYGICef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 22:34:35 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:2907 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYGICef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 22:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xbZrLA3TTllEADDAbjnaPmh8qkkuWT3uiEJ/U3cpCRDujI5AaX9tNV9QjxfcJV0bxx
         y2WILJkWWQ1Yi/n82bfkf6U8egBr5+XGGlE++Ktp197nlcawMRVmAGKWhAEQkNnelh20
         EYVblCdLm4v7HbL39a/0vubwk5N0dGcQFsjzY=
Message-ID: <487423B3.3010604@gmail.com>
Date: Wed, 09 Jul 2008 10:34:27 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stefan Schmidt <stefan@datenfreihafen.org>
CC: Daniel Ribeiro <drwyrm@gmail.com>, pHilipp Zabel <philipp.zabel@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, sameo@openedhand.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile
 phones
References: <20080707184000.411913919@datenfreihafen.org> <20080707184129.554483476@datenfreihafen.org> <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com> <20080707200251.GA3449@datenfreihafen.org> <48730DE2.2050302@gmail.com> <4873734F.4030808@gmail.com> <20080708203213.GF18479@datenfreihafen.org>
In-Reply-To: <20080708203213.GF18479@datenfreihafen.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> o Eric, what do you like the PCAP_REDIRECT_IRQ flag to do?
> 

I'm seeing the following the block of code in the original patch:
 
+/* PCAP */
+static int ezx_pcap_init(void)
+{

...

+	/* redirect all interrupts to AP */
+	if (!(machine_is_ezx_a780() || machine_is_ezx_e680()))
+		ezx_pcap_write(PCAP_REG_INT_SEL, 0);
+
+	return 0;
+}

that prevent this driver from being generic, a flag of PCAP_REDIRECT_IRQ
might be used to decide the writing to PCAP_REG_INT_SEL is necessary.

