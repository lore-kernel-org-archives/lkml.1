Return-Path: <linux-kernel-owner+w=401wt.eu-S1764229AbXESSMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764229AbXESSMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbXESSMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:12:37 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:52578 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbXESSMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:12:36 -0400
Date: Sat, 19 May 2007 20:12:15 +0200
Message-Id: <1799168144@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: khc@pm.waw.pl
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] LZO1X de/compression support
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/QYmKS5ugbXS3ADUEWPFwmfnQ92lvyHwAMRNeRVi2RCp3JN
 IIHvTBsmXwyy6Iq3xln2CXi0/EnMaKBDwiq109dIlfqoA8/ZLg=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>I'm certainly missing something but what are the advantages of this
>code (over current gzip etc.), and what will be using it?

lzo compresses/decompresses much faster and using less cpu

this is how it compares:

bzip2:  best compression, but damn slow performance
gzip: good compression with good performance
lzo:  not that good compression but stunning performance 

reiser4 and compressed caching is alrady using lzo compression, but they bring their own implementation - there are other projects which could make use of it - so it`s better to share the code by making it an integral part of the kernel.

roland

> Facts for LZO (at least for original code. Should hold true for this
> port also - hence the RFC!):
> - The compressor can never overrun buffer.
> - The "non-safe" version of decompressor can never overrun buffer if
> compressed data is unmodified. I am not sure about this if compressed
> data is malicious (to be confirmed from the author).
> - The "safe" version can never crash (buffer overrun etc.) - confirmed
> from the author.

I'm certainly missing something but what are the advantages of this
code (over current gzip etc.), and what will be using it?
-- 
Krzysztof Halasa
_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

