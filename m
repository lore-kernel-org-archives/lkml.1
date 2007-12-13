Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbXLMVLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbXLMVLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932352AbXLMVLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:11:07 -0500
Received: from picture.zai.com ([12.47.112.36]:48555 "EHLO york.rivers.zai.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765022AbXLMVLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:11:06 -0500
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 16:11:05 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: Per process control of core file naming
Date: Thu, 13 Dec 2007 15:54:48 -0500
Message-ID: <D108F32273D3044F8C7B24328CB7713701A365@york.rivers.zai.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Per process control of core file naming
Thread-Index: Acg9ymX8tBIyOxDkSdyEnAvGDNUWcw==
From: "Sanders, Rob M." <sanders-rob@zai.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
  I know I can use the /proc/sys/kernel/core_pattern and /proc/sys/kernel/core_uses_pid files to 
control core filenaming for *all* core files on a system, but is there a way for a particular 
process to have control of its own core file names?  The down side to the current way Linux does this now
is that *all* processes are affected, requiring someone with root/sudo access (or someone with
said privs to chmod these files) to change the behavior.  It would be nice for a process/programmer
to have finer grain control (subject to override by /proc/sys/kernel/core*) on the names of the 
core files.
  Tru64's has this, as 'enhanced core file naming', where a process can decide at runtime how a 
file will be named (still being written to the CWD if space/permissions allow).
  I'd found this feature to be quite useful several years ago on a Tru64 cluster, where I had 
multiple instances of the same executable running across the cluster.  It was very nice
to be able to turn on and off the enhanced naming ( core.program_name.host_name.numeric_tag)
as I needed to, without requiring everyone *else* to use the same naming conventions.
   
Thanks...

Rob
