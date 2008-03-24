Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbYCXPFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbYCXPFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbYCXPEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:04:55 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:7697 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbYCXPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=F514fmJR2utEWHiso7l+th0CVcXkNcBeujZ3k3iGS7wnE6MJYo2f8uz/J7pcqd2S/JJ+eM2U6pr91gASxkOMs4/5lwSapvGkHXw/oZiI4P8MwIJuTx6rlZ3oJhOpGIBoRp2MnHcSRmz1tT0wtjf7EHJ7sVEpjR8LAnwNYxHDIwA=
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: nitingupta910@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6]: compcache: Compressed Caching
Date: Mon, 24 Mar 2008 20:30:05 +0530
User-Agent: KMail/1.9.9
Cc: linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803242030.05997.nitingupta910@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

(sending to lkml since I didn't get any reply at linux-mm).

This implements a RAM based block device which acts as swap disk.
Pages swapped to this disk are compressed and stored in memory itself.
This allows more applications to fit in given amount of memory. This is
especially useful for embedded devices, OLPC and small desktops
(aka virtual machines).

Project home: http://code.google.com/p/compcache/

It consists of following components:
- compcache.ko: Creates RAM based block device
- tlsf.ko: Two Level Segregate Fit (TLSF) allocator
- LZO de/compressor: (Already in mainline)

Project home contains some performance numbers for TLSF and LZO.
For general desktop use, this is giving *significant* performance gain
under memory pressure. For now, it has been tested only on x86.

Thanks,
Nitin
