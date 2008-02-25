Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYBYTQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYBYTQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYBYTQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:16:20 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:11570 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYBYTQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:16:19 -0500
Date: Mon, 25 Feb 2008 11:14:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, avi@qumranet.com
Cc: linux-next@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: voyager/KVM build problem
Message-Id: <20080225111433.827055bd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I could have sworn that we had patches that made KVM
depend on !VOYAGER and !VISWS, but with 2.6.25-rc3 and linux-next,
it's possible to select VOYAGER machine type (x86_32) and then
enable KVM and watch the build fail.

ERROR: "smp_ops" [arch/x86/kvm/kvm.ko] undefined!
make[1]: *** [__modpost] Error 1

---
~Randy
