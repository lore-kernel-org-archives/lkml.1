Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZLVTqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZLVTqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZLVTqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:46:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:36778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZLVTqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:46:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vmIvd6golkEkThbyed6eOMbVQ87AF7z5jLYMxhlwJHv9ZXkQO40HY0dy3XiGS2+Fry
         Fkodoz+SOFPVXi7cb0Gv0ZXEWYX4K730C41d8f1KSLgyaxE84VE3w5dvltvA4qFNtU9G
         BRVy8ilI+tCoh/zb6JdMfn3UaKTcnZ9oohKm4=
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 14:46:30 -0500
Message-ID: <b3eb0ed40912221146y70fd90f2j3c5b45f95a57b689@mail.gmail.com>
Subject: Oops in 2.6.27.39 vanilla with latest DTrace linux port - 
	dtrace-20091010.tar.bz2
From: Soumendu Satapathy <satapathy.soumendu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

10/10/2009 09:50PM        814,999 dtrace-20091010.tar.bz2  ( I used
this tarrball )

I was able to use the DTrace perfectly well with 2.6.18 (x86_64). But
I had problems with the latest DTrace  port on 2.6.27.39.(x86_64).

I did the following changes inside the routine mem_set_writable() (
driver/dtrace_linux.c) and I could make it work with 2.6.27.39.

if (pmd_large(*pmd)) {
                pte = (pte_t *)pmd;
}
else {
                pte = pte_offset_kernel(pmd, addr);
 }

thanks
Soumendu Sekhar Satapathy
