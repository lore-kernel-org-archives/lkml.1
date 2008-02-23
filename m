Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbYBWNXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbYBWNXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYBWNWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:22:54 -0500
Received: from alpha.facton.com ([83.236.152.122]:46110 "EHLO alpha.facton.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbYBWNWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:22:53 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: zlib oops with ipcomp in 2.6.24
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Sat, 23 Feb 2008 14:22:38 +0100
Message-ID: <3C59DB883F7B0B4D8096010D45ACCD134F2112@exch.facton.local>
In-Reply-To: <20080223000328.3a71e858.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: zlib oops with ipcomp in 2.6.24
Thread-Index: Ach18qv+4vb3d7+tTrmA/wFb7wi9uAALAD4g
References: <3C59DB883F7B0B4D8096010D45ACCD134F210D@exch.facton.local> <20080223000328.3a71e858.akpm@linux-foundation.org>
From: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "Richard Purdie" <rpurdie@rpsys.net>,
       "Herbert Xu" <herbert@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The Oops:
>> 
>> invalid opcode: 0000 [1] SMP

> There's a line missing here.  Which of the BUG statements which you
added
> has triggered?

lookahead = -1 strstart = 185
------------[ cut here ]------------
kernel BUG at lib/zlib_deflate/deflate.c:1255!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 3978, comm: httpd Not tainted 2.6.24 #10
...
