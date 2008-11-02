Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYKBCXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYKBCXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYKBCXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:23:41 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:34650 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYKBCXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:23:41 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 0/6] x86: unify fixmap.h
Date: Sun,  2 Nov 2008 00:23:47 -0200
Message-Id: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theses patches unify the fixmap_(32|64).h into fixmap.h
Some things was left with '#ifdef CONFIG_X86_(32|64)' because first we
need to integrate things like vsyscall, efi, pci_mmconfig, FIXADDR_TOP
and FIX_WP_TEST.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>


