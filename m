Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYDHJly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYDHJly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYDHJlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:41:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55286 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799AbYDHJlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:41:45 -0400
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: nitingupta910@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] compcache: compressed caching v2
Date: Tue, 8 Apr 2008 14:59:27 +0530
User-Agent: KMail/1.9.9
Cc: linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081459.27382.nitingupta910@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

(This revision contains all changes suggested in initial review).

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
under memory pressure. For now, it has been tested on x86 and x86_64.

Thanks,
Nitin
