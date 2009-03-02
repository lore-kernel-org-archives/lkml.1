Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZCBWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZCBWyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZCBWyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:54:11 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:10768 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZCBWyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=sRkrQvIf6Qp8EmZusXBqdRU1R/53FBn0DcH43RSxDWh2Ldn0PAf0Sz48+5mZDapDZv
         XNpT+TseNhnH7pqO0ZJoxGATnNki0V01WQC+DtxF+s89JUV6DiXH429E0JhV42tC4jFw
         QaTYdeozo9Kl8gIhMBhCJUHtJRVewbC0kgvx4=
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 14:54:06 -0800
Message-ID: <8c6189ae0903021454t1480e3a6u16532de024f0a458@mail.gmail.com>
Subject: No symbol version for PROM_KMALLOC1 in kernel 2.6.26
From: P Mumbai <mumbai.prasanna@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to get my driver working on 2.6.26 kernel. This driver
works fine in 2.6.17 kernel.

I have a glue KLM(kernel loadable module) & the main driver KLM.   The
Glue module exposes a set of API's which the main driver KLM uses.

I have a glue layer which exposes a function called "PROM_KMALLOC1".
This function is exported using "EXPORT_SYMBOL(PROM_KMALLOC1)".  I
load the glue KLM and then load the main driver KLM.
The reference to PROM_KMALLOC1 in my main driver is giving me the
following error.

be:  no symbol version for PROM_KMALLOC1
be: Unknown symbol PROM_KMALLOC1

Is there a different way of exporting symbols in 2.6.26 kernel ?   I
don't know what does symbol version mean ?  Can anyone explain me
please.

i did
[root@localhost ~]# cat /proc/kallsyms | grep PROM_KMALLOC1
e22352d4 r __ksymtab_PROM_KMALLOC1      [glue]
e22358ba r __kstrtab_PROM_KMALLOC1      [glue]
e223542c r __kcrctab_PROM_KMALLOC1      [glue]
e204d048 T PROM_KMALLOC1        [glue]
d8bc05b7 a __crc_PROM_KMALLOC1  [glue]

~Cheers
Prasanna
