Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZKUEnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZKUEnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 23:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZKUEnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 23:43:24 -0500
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:45974
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbZKUEnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 23:43:24 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 23:43:23 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAA/8BkvL1mFu/2dsb2JhbADHFI5ChDwE
X-IronPort-AV: E=Sophos;i="4.47,262,1257091200"; 
   d="scan'208";a="71387637"
Date: Sat, 21 Nov 2009 14:34:03 +1000
From: muradaikan <muradaikan@momonga-linux.org>
To: linux-kernel@vger.kernel.org
Subject: /usr/include/linux/netlink.h should have #include <sys/socket.h> ?
Message-Id: <20091121143403.36a16221.muradaikan@momonga-linux.org>
Organization: Momonga Linux Project
X-Mailer: Sylpheed 3.0.0beta2 (GTK+ 2.18.3; x86_64-momonga-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently /usr/include/linux/netlink.h has 

 #include <linux/socket.h> /* for sa_family_t */

and <linux/socket.h> contains ss_family but <sys/socket.h> has sa_family.

So should the line be

 #include <sys/socket.h> /* for sa_family_t */

in /usr/include/linux/netlink.h ?

Thanks,
muradaikan
