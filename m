Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZGUQxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZGUQxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZGUQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:53:13 -0400
Received: from tango.0pointer.de ([85.214.72.216]:44086 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZGUQxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:53:13 -0400
Date: Tue, 21 Jul 2009 18:52:48 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: linux-kernel@vger.kernel.org
Subject: Can access to /proc/$PID/exe be relaxed?
Message-ID: <20090721165248.GA27549@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Unless I am mistaken a process currently needs CAP_SYS_PTRACE to read
/proc/$PID/exe for abritrary processes. Does that make sense? Could
that be relaxed? Is there any reason to limit access to that link at
all? To me the data from /proc/$PID/cmdline seems to be far more
worthy to be protected than /proc/$PID/exe, or am I missing something?

Tbh, looking at the code I don't really get where CAP_SYS_PTRACE seems
to be required, but experimenting from userspace this seems to be the
case.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
