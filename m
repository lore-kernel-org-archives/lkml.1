Return-Path: <linux-kernel-owner+w=401wt.eu-S932909AbZAQXaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909AbZAQXaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761666AbZAQX3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:29:55 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:43199 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761625AbZAQX3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:29:54 -0500
X-Greylist: delayed 3819 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2009 18:29:54 EST
From: David Wagner <daw@cs.berkeley.edu>
Message-Id: <200901172226.n0HMQEEJ024690@taverner.cs.berkeley.edu>
Subject: Checking module parameters
To: linux-kernel@vger.kernel.org
Date: Sat, 17 Jan 2009 14:26:14 -0800 (PST)
Secret-Bounce-Tag: 9a029cbee41caf2ca77a77efa3c13981
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to tell what options have been applied to a currently
loaded kernel module?

I'm trying to force libata to use 1.5Gbps rather than 3Gbps, so I created
a file /etc/modprobe.d/local containing:
  options libata force=1.5Gbps
However my SATA drive gets loaded at 3Gbps.  I'm trying to figure out how
to debug this so that I can tell whether the option got correctly applied
to the libata module, and if not, how to force the SATA link to 1.5Gbps.
Any suggestions or ideas?

(I can't set libata.force=1.5Gbps as a kernel argument because on my
Fedora kernel, libata is loaded as a module rather than built into the
kernel.  I can't run "modprobe libata force=1.5Gbps" by hand because
I've got SATA drives, so the libata module is automatically loaded before
I get shell access.)
