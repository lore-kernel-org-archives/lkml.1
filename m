Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbYEOR42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbYEOR42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763154AbYEOR4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:56:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763139AbYEOR4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:56:01 -0400
Message-Id: <20080515175357.636334082@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 13:53:57 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: [patch 0/5] access_process_vm device memory access
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to debug things like the X server and programs
using the PPC Cell SPUs, the debugger needs to be able to access
device memory through ptrace and /proc/pid/mem.

Changelog:
 - use CONFIG_HAVE_IOREMAP_PROT
 - do not use generic_access_phys as a fallback but define it in
   the ->vm_ops->access for appropriate VMAs
 - other code cleanups suggested by Andrew Morton and Sam Ravnborg

-- 
All Rights Reversed

