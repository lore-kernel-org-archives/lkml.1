Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbXCEXzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbXCEXzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932511AbXCEXzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:55:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:38176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbXCEXzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:55:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gu5Ov7/rJzs+P3b8TZAJQSYatv+C7c+wcg5jxHmLvw0pKqZQfENr6H4ZV+UVntoU2QwfkYhS494Q+xrWt3g/qTai/nYfObBp2zyHx1pxp4rFsmq456YlXH2ooiuC+jFEnqeRgzZBnjFE87Tw3DKkXijgxisHVnkD2IbtfQ6vtoY=
Message-ID: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
Date: Mon, 5 Mar 2007 15:55:06 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: PAGE_SIZE Availability Inconsistency
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was rtfc'ing the code one day and noticed somethings about the
PAGE_SIZE define that is kinda inconsistent around its relative
location to the __KERNEL__ define.

On some architectures the PAGE_SIZE is outside the __KERNEL__ define
(i386 and x86_64) and on others its inside the define (ia64 and
powerpc).  I was wondering if this is because the powerpc and ia64
architectures have dynamic page sizes so that's why they can't export
PAGE_SIZE outside __KERNEL__.

I'm kinda wondering how I'm supposed to write portable user-space code
if I want to use the PAGE_SIZE define on different architectures.

Thanks,
- David Brown
