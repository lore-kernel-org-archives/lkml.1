Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbXCMMaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbXCMMaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933227AbXCMMaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:30:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140AbXCMMaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:30:13 -0400
Date: Tue, 13 Mar 2007 09:30:11 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: akpm@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Remove duplicated code for reading control registers
Message-ID: <20070313123011.GG10126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tiny cleanup:

In x86_64, the same functions for reading cr3 and writing cr{3,4} are
defined in tlbflush.h and system.h, whith just a name change.
The only difference is the clobbering of memory, which seems a safe, and
even needed change for the write_cr4. This patch removes the duplicate.
write_cr3() is moved to system.h for consistency.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"
