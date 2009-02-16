Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZBPMCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZBPMCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZBPMCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:02:09 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:60046 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZBPMCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:02:08 -0500
Date: Mon, 16 Feb 2009 13:01:36 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: "elf core dump: fix get_user use" breaks mips compilation
Message-ID: <20090216120136.GA9057@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

Your change "elf core dump: fix get_user use"  (which made it into
2.6.28.5) breaks the compilation on MIPS (which sets -Werror):

  CC      arch/mips/kernel/binfmt_elfn32.o
cc1: warnings being treated as errors
arch/mips/kernel/../../../fs/binfmt_elf.c: In function ‘vma_dump_size’:
arch/mips/kernel/../../../fs/binfmt_elf.c:1202: warning: ‘word’ may be used uninitialized in this function
make[1]: *** [arch/mips/kernel/binfmt_elfn32.o] Error 1

-- 
Martin Michlmayr
http://www.cyrius.com/
