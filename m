Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXBEPtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXBEPtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 10:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbXBEPtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 10:49:52 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:33313 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751068AbXBEPtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 10:49:51 -0500
X-VirusChecked: Checked
X-Env-Sender: Scott_Kilau@digi.com
X-Msg-Ref: server-7.tower-29.messagelabs.com!1170690590!1102!1
X-StarScan-Version: 5.5.10.7.1; banners=-,-,-
X-Originating-IP: [66.77.174.21]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: 2.6.20 doesn't compile with gcc-3.2.2
Date: Mon, 5 Feb 2007 09:49:49 -0600
Message-ID: <335DD0B75189FB428E5C32680089FB9F012DCBB3@mtk-sms-mail01.digi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: 2.6.20 doesn't compile with gcc-3.2.2
Thread-Index: AcdJPURsxcUEqCGcQjGUqYLgU8l9zg==
From: "Kilau, Scott" <Scott_Kilau@digi.com>
To: <linux-kernel@vger.kernel.org>
Cc: <a1426z@gawab.com>
X-OriginalArrivalTime: 05 Feb 2007 15:49:50.0286 (UTC) FILETIME=[4500C6E0:01C7493D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> > objcopy: arch/i386/boot/compressed/vmlinux.bin: File truncated
> > make[2]: *** [arch/i386/boot/compressed/vmlinux.bin] Error 1
> > make[1]: *** [arch/i386/boot/compressed/vmlinux] Error 2
> > make: *** [bzlilo] Error 2

I got the same as well here on my box.

I am using Red Hat 9, with a lot of things upgraded.

I found other "hints" that this might be a binutils issue,
which obviously hasn't been touched in years on Red Hat 9,
so I picked up the binutils built for Fedora Core 3,
and installed them...

That solved the problem.

Scott Kilau



