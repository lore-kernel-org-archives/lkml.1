Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbXEEW3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbXEEW3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 18:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXEEW3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 18:29:40 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:40384 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbXEEW3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 18:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LAvXCv9f2HnXaQpujWxkrAG4MtxN/9kqsq9I+ltAsa6DMybFq2epwprny9ItrDKX+M4iKVFeQmdv7mXH3X4uoBbsOPLu6zRXc0kUA9FyuW/s6JRlEmxXkffDTgpPkWYnyJ8yx3E6U/roTCI72nIgG3pBmj8iSaQ9pCIuE7Qtars=
Message-ID: <c384c5ea0705051529r41164c6dq8ece7da99c324c78@mail.gmail.com>
Date: Sun, 6 May 2007 00:29:39 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [ext3] journal commit interval
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

this is something I have long wondered about but have been afraid to ask.

When my system is chewing away on builds, the disk I/O write access
pattern of my ext3 root filesystem (using CFQ, Intel SATA controller,
hard disk) when visualized by GNOME System Monitor clearly shows a
repetitive landscape of large peaks, 5 seconds apart, which not much
activity inbetween.

I understand that's due to the ex3 journal commit interval (defaults
to 5 seconds).

But why isn't the filesystem continuously committing only that part of
the journal that is older than 5 seconds?

I would then expect the write requests to be smoothened over time,
which can only be good in terms of performance and low latency.

Regards,
-- 
Leon
