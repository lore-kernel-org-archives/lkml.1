Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbYCYWEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbYCYWEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYCYWD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:03:56 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:42560 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbYCYWDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kVzFphMk44cL9u1lEY0K7bE5wGw41p2miWTSLu8DnTwRyUxrCaOpBfNCvbTuDeOOjX5hJckmhhaUJ1MdDD611iEPEP8U9E04qbcGQsMg5+0FEUGJLfyw94QV0Fu2fjFMfxU1aT21tsvRS3SckEqAKEG+VGSNzXq9asP/gCMEOpY=
Message-ID: <998d0e4a0803251503v7bf20ad4ndb0e21b1eead7f9d@mail.gmail.com>
Date: Tue, 25 Mar 2008 23:03:54 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: What means Hugepage? 8KiB,16KiB,..,2MiB or 4MiB?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What means Hugepage?

Does it mean 8KiB? 16KiB? 32KiB? 64KiB? 2MiB? 4MiB?

The real page sizes of x86 and x86-64 are 4 KiB for this linux kernel.

But the page sizes can be soft 8 KiB or 16 KiB or 32 KiB or 64 KiB
if it is implemented in the memory manager of the kernel.

But too they exist real page sizes of 2 MiB and 4 MiB that they have
some reserved entries of TLB in the specs of Intel/AMD processors
for these gigant pages.
