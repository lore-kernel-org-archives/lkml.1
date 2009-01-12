Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZALKXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZALKXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZALKX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:23:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:56760 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750984AbZALKX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:23:26 -0500
Date: Mon, 12 Jan 2009 11:23:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org
Subject: build breakage -- paravirt_{alloc,free}_ldt
Message-ID: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with Linus' tree (ae04d14015) doesn't build for me with

arch/x86/kernel/ldt.c: In function 'alloc_ldt':
arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'

Config on http://www.jikos.cz/jikos/junk/.config

-- 
Jiri Kosina
SUSE Labs
