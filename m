Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXF2FDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXF2FDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXF2FDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:03:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:58803 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXF2FDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jwEVrYi3Skc48uwOTyLvx2Ak+hWQPFIDl/qov76KRWd6zy5WmpIn6M40kV6DMIEmH8HamR3kno7f33WFlgyuvInSQ2a37X4qDX1vQFVcC7xGd+q4ORlRz+YuLcgNSHzyLnVUkUkc3xtZPmeOt4oK0OZA7IB0HzpA1pn/RyIFojo=
Message-ID: <af3ea28a0706282203r16764118vd163cb48a25d9d99@mail.gmail.com>
Date: Fri, 29 Jun 2007 13:03:06 +0800
From: "ye janboe" <janboe.ye@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: is this a bug of elf_core_dump
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I found there are codes like following in elf_core_dump
		for (addr = vma->vm_start;
		     addr < vma->vm_end;
		     addr += PAGE_SIZE) {
			struct page *page;
			struct vm_area_struct *vma;

			if (get_user_pages(current, current->mm, addr, 1, 0, 1,
						&page, &vma) <= 0) {
				DUMP_SEEK(PAGE_SIZE);
			} else {


does get_user_pages directly use page variable which is not
initialized is a bug?

thanks

Janboe
