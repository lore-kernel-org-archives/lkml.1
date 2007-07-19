Return-Path: <linux-kernel-owner+w=401wt.eu-S1763807AbXGSLds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763807AbXGSLds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXGSLdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:33:41 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:57007 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbXGSLdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:33:40 -0400
Message-ID: <469F4BBF.6080904@googlemail.com>
Date: Thu, 19 Jul 2007 13:32:15 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: New 'Section mismatch:' warning in current git
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on current git head I see this new warning caused by commit
c70df74376c1e29a04e07e23dd3f4c384d6166dd

...

  MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0xc290): Section mismatch:
reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and
'initialize_secondary')
WARNING: arch/i386/kernel/built-in.o(.text+0xc29e): Section mismatch:
reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and
'initialize_secondary')

...




Regards ,

Gabriel C


