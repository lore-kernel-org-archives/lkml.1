Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbYGOAjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbYGOAjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbYGOAjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:39:41 -0400
Received: from mail.crca.org.au ([67.207.131.56]:34707 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbYGOAjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:39:41 -0400
X-Bogosity: Ham, spamicity=0.090466
Subject: Current head x86_64 breakage - csum-copy_64.S
From: Nigel Cunningham <ncunningham@crca.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Tue, 15 Jul 2008 10:39:38 +1000
Message-Id: <1216082378.25534.43.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Perhaps this is just bad timing but I'm getting:

  AS      arch/x86/lib/csum-copy_64.o
arch/x86/lib/csum-copy_64.S: Assembler messages:
arch/x86/lib/csum-copy_64.S:48: Error: Macro `ignore' was already
defined
make[1]: *** [arch/x86/lib/csum-copy_64.o] Error 1
make: *** [arch/x86/lib] Error 2

The previous definition appears (brief examination) to be in
asm/dwarf2.h.

Regards,

Nigel

