Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbXJOXkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXJOXkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbXJOXjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:39:52 -0400
Received: from main.gmane.org ([80.91.229.2]:57711 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736AbXJOXjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:39:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Johan Brannlund <johan_brn@yahoo.com>
Subject: Lots of disk activity on resume from s2ram
Date: Mon, 15 Oct 2007 21:53:21 +0000 (UTC)
Message-ID: <pan.2007.10.15.21.53.21@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: blk-137-105-82.eastlink.ca
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. I've noticed that with recent kernels (starting somewhere between 
2.6.20 and 2.6.22) I sometimes get *lots* of disk activity on resume from 
suspend to ram. About 2/3 of the time, the system resumes normally but in 
the remaining 1/3 of the time, the hard drive light stays on almost solid 
and the machine is very, very slow to respond. The only way I've found to 
reliably recover from this is if I can get to a command prompt fast 
enough and do "shutdown -r now". There's not much cpu activity at all, it 
just seems to be disk io that's killing interactivity. This also happens 
if I resume just from an empty gnome desktop with no applications 
running, so I don't think it's due to swapping.

Some kernels affected: 2.6.22, 2.6.23+hrt patches, Ubuntu Gutsy kernel 
(2.6.22-14). These are all 64-bit kernels running on an HP nx6125 laptop 
- single-core Turion 64 processor, 1 gig of ram. To the best of my 
recollection, this problem did *not* appear with 2.6.20.

I put some dmesg output from the vm block dumping and some vmstat output 
at http://nullinfinity.org/tmp/s2ram/ . The dmesg logs are from the same 
resume, just a little while apart. The vmstat is from a different resume.

Any workarounds, patches, tips for further debugging etc would be 
appreciated.

- Johan

