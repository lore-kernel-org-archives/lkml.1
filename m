Return-Path: <linux-kernel-owner+w=401wt.eu-S1761052AbYAROnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761052AbYAROnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbYAROnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:43:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42598 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbYAROnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:43:11 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: UML is leaking memory in arch_dup_mmap
Message-Id: <E1JFsQo-0000aG-BZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 15:42:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.24-rc8-mm1:

uml:~#  grep arch_dup_mmap /proc/slab_allocators
size-32: 10861 arch_dup_mmap+0x9f/0x130

Miklos
