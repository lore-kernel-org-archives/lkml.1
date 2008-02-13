Return-Path: <linux-kernel-owner+w=401wt.eu-S1764002AbYBMAP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764002AbYBMAP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYBMAPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:15:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbYBMAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:15:50 -0500
Date: Tue, 12 Feb 2008 19:15:32 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: asm-x86/sigcontext.h changes break userland
Message-ID: <20080213001532.GJ24887@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The

x86: use generic register names in struct sigcontext
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=742fa54a62be6a263df14a553bf832724471dfbe

changeset breaks userland, e.g. it is not possible to compile gcc anymore
(both 32-bit and 64-bit libgcc), and I expect any other program which pokes
into struct sigcontext.  The register names with e resp. r have been in use
for years, what's the point breaking it now?

	Jakub
