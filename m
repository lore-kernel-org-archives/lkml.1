Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbYHSUDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbYHSUDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYHSUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:03:12 -0400
Received: from gw.goop.org ([64.81.55.164]:38786 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbYHSUDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:03:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 3] define and use phys_addr_t
Message-Id: <patchbomb.1219176169@localhost>
Date: Tue, 19 Aug 2008 13:02:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ehabkost@redhat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series:
 - adds a globally defined phys_addr_t, replacing the
   arch-specific x86 and powerpc ones
 - makes PFN_PHYS return a phys_addr_t
 - redefines resource_size_t as phys_addr_t

The first two are bugfixes and should be applied to git.

Thanks,
	J

