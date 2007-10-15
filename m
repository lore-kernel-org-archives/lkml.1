Return-Path: <linux-kernel-owner+w=401wt.eu-S1764639AbXJOGzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764639AbXJOGzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbXJOGy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:54:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:26590 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbXJOGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OdQRvTf9URpw+JOGeGseqAp4UqGS6TQrTMc3tGSf0mlYWwknIUg4R5FR+XpChVvfLwBupRPVYA6e7GmS61B433C3DS9Uwi8MeBT3f4lcyxtVcE81l4eQazI9sTAtMYZp/nj14ZgscimwC5FSjjGPGsR0u1oTyLdz0q8epbPfyvk=
Message-ID: <35f686220710142354k66e1b9acwf65864b138ffd26@mail.gmail.com>
Date: Mon, 15 Oct 2007 12:24:55 +0530
From: "Alok kataria" <alokkataria1@gmail.com>
To: "Andi Kleen" <ak@suse.de>, hugh@veritas.com
Subject: ARCH_FREE_PTE_NR 5350 on x86_64
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at the tlb_flush code path and its co-relation with
ARCH_FREE_PTE_NR, on x86-64 architecture. I think we still don't use
the ARCH_FREE_PTE_NR of 5350 as the caching value for the mmu_gathers
structure, instead fallback to using 506 due to some typo errors in
the code.

Found this link in the archives.

http://www.ussg.iu.edu/hypermail/linux/kernel/0509.1/1821.html

I don't think anything has been done on this yet (looked at 2.6.23).
Do let me know if its only a typo that needs a fix, or we are still
waiting for some other other changes to come into effect.

Thanks,
Alok.
