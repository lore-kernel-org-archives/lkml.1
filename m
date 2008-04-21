Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYDUXsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYDUXsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYDUXsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:48:15 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:41389 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbYDUXsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:48:14 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 19:48:14 EDT
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <480D2151.2020701@avtrex.com>
Date: Mon, 21 Apr 2008 16:20:49 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/6] MIPS Hardware watchpoint support for gdb.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2008 23:20:50.0131 (UTC) FILETIME=[56193230:01C8A406]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds hardware watch register support for MIPS to
the kernel.  This is kind of a chicken-and-egg type of problem as you
need gdb support to test it, but you cannot test gdb until the kernel
support is present.  These kernel patches are preliminary and
undoubtedly will need some tweaking.

If you want to test this out, you will need to build a suitable gdb
using the patch here:

http://sourceware.org/ml/gdb-patches/2008-04/msg00439.html

The patches are against current linux-mips.org (commit
096bc9f852d4e782b318218d82181f4b09bac63f)

My main test platform only runs 2.6.15, so I could not fully test them
in the current kernel.  I did test under Qemu, but since it lacks full
watch register support in mips, I could not verify that it really works
there.

Well without further ado, here they come.

David Daney

