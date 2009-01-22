Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZAVMvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZAVMvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZAVMvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:51:38 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:51574 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZAVMvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:51:38 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2009 07:51:38 EST
Message-ID: <49786A59.6040706@walrond.org>
Date: Thu, 22 Jan 2009 12:45:13 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.28 headers break kbd and net-tools userspace builds
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaks kbd like this:

  /usr/include/linux/serial.h:164: error: expected 
specifier-qualifier-list before '__u32'

and net-tools like this:

  In file included from /usr/include/linux/if_tunnel.h:5,
                   from iptunnel.c:39:
  /usr/include/linux/ip.h:85: error: redefinition of 'struct iphdr'

Both build fine with 2.6.27.10 headers.

Hope that's useful.

Andrew Walrond

