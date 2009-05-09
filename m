Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZEICZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZEICZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 22:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZEICZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 22:25:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:44899 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZEICZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 22:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Q8Dw7tYNIOM2/UtxdxY7w6puOr1sN/HuuXQnfE1OAAJQ5pLa4V246fl9ewXOxp1W45
         0gwhjBVwt2KwvTY21v4t+j25s9+8jJirpFtvZZwr/ya9b0WYRnIdxxzc0ONATwGz+K0t
         A1ZJ31PzaSOJnF5T/Z8vQUgXxJhPZMS8R6B98=
MIME-Version: 1.0
Date: Sat, 9 May 2009 10:25:29 +0800
Message-ID: <d364733c0905081925y795fefc3ie76515609c95cf3e@mail.gmail.com>
Subject: Can I/O order be guaranteed by submitting sycn bio
From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some journal file systems submits sycn bio to do ordered write  if the
device does not support barrier i/o. But the sync bio only implies the
unplug of the request queue. Some elevators may reorder the request.
It's seems that the bio only with BIO_RW_SYNC flag could not guarantee
the write order. Is this true?

If so, is there any better way to do ordered write when there is no
barrier i/o support.

Thanks,

-- 
Xie Gang
