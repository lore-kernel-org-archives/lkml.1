Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYAHRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYAHRqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbYAHRq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:46:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:51832 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYAHRqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:46:25 -0500
Message-Id: <B239D728-5354-42F7-90E6-DE19429D0FBF@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: reserving a region of highmem at boot time
Date: Tue, 8 Jan 2008 11:46:16 -0600
Cc: linux-mm@kvack.org
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to mark a page if its in highmem as reserved at boot  
time?

I'm on a ppc32 system and we are trying to ensure that the last page  
of memory isn't used by the kernel.

I see reserve_bootmem but that seems to only deal with low memory.

thanks

- k
