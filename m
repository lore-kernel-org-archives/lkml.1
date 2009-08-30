Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZH3Nqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZH3Nqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZH3Nqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:46:34 -0400
Received: from www.tglx.de ([62.245.132.106]:53091 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbZH3Nqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:46:34 -0400
Message-Id: <20090830134446.843410397@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 30 Aug 2009 13:46:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [patch 0/3] x86: Early platform detection based on boot param subarch
	id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown needs to tweak x86_init functions in the early boot
process. Moorestown can be identified by subarch id in the boot
params. The following series implements the necessary change in the
early boot code and hooks up MRST early setup.

Thanks,

	tglx

