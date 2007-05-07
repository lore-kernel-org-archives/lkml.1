Return-Path: <linux-kernel-owner+w=401wt.eu-S967229AbXEGXbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967229AbXEGXbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967224AbXEGXa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:30:59 -0400
Received: from flpvm23.prodigy.net ([207.115.20.53]:16610 "EHLO
	flpvm23.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967223AbXEGXa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:30:58 -0400
X-ORBL: [69.177.4.52]
Message-ID: <463FB6B0.3070005@pcburn.com>
Date: Mon, 07 May 2007 19:30:56 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Getting make net/built-in.o Error with 2.6.21.1 Build
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On trying to build a 2.6.21.1 kernel using the configuration at 
http://pcburn.com/files/kernel/breaks.2.6.21.1.config I'm getting the 
following error with Networking Support -> Bluetooth Subsystem Support 
-> HIDP protocol support set to built-in:

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
net/built-in.o: In function `hidp_add_connection':
(.text+0x8bb08): undefined reference to `hid_ff_init'
make: *** [.tmp_vmlinux1] Error 1

Works with that option turned off.  Also, the GCC version I'm using is 
the current Debian Etch release: gcc (GCC) 4.1.2 20061115 (prerelease) 
(Debian 4.1.1-21).  I also tried it with gcc (GCC) 3.4.6 (Debian 
3.4.6-5) for the same result.

I don't need to build that, so I simply unset it.  If this is at all 
useful and you need something else just CC: me in the reply.

Thanks,
-- Chris
