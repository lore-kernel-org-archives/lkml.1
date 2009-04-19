Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbZDSWBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbZDSWBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZDSWB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:01:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:19034 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDSWB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ZpAp3fo4UTdDTxCTOZ48JiQsIjJDD5cQdcQiaVvA/yFGLwMid32EQQrDRyKBUshHVo
         SRhY872uGcPEPBoJF9Xd5U4zGomldLzAtNbHDpC68NTuHTfH+r8aN+Sv1TVqaYAFhZ8q
         7rnIAumZmuFm85/vpbqCaYCyqiuGjcjZS99pA=
MIME-Version: 1.0
Date: Sun, 19 Apr 2009 15:01:27 -0700
Message-ID: <dd18b0c30904191501r62054705kcc2866cfd86a9f1e@mail.gmail.com>
Subject: arch/x86/mm/pgtable.c:352: error: incorrect sharing of tree nodes
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well I've just put in the latest gcc and am hitting errors
with libc, and now the kernel:

  CC      arch/x86/mm/pgtable.o
arch/x86/mm/pgtable.c: In function 'pgd_prepopulate_pmd':
arch/x86/mm/pgtable.c:352: error: incorrect sharing of tree nodes
D.24886.pud.pgd = swapper_pg_dir[i];

swapper_pg_dir[i]
arch/x86/mm/pgtable.c:352: internal compiler error: verify_stmts failed
Please submit a full bug report,
with preprocessed source if appropriate.
See <http://gcc.gnu.org/bugs.html> for instructions.
make[1]: *** [arch/x86/mm/pgtable.o] Error 1
make: *** [arch/x86/mm] Error 2


sounds like I'm downgrading gcc..

-- 
Justin P. Mattock
