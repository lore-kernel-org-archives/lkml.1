Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYHANbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYHANbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYHANbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:31:03 -0400
Received: from main.gmane.org ([80.91.229.2]:33263 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYHANbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:31:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh S <halesh.s@india.com>
Subject: Need inforamtion on execve(2) on ENOMEM
Date: Fri, 1 Aug 2008 13:30:46 +0000 (UTC)
Message-ID: <loom.20080801T132557-530@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 125.17.166.34 (Opera/9.50 (Windows NT 5.1; U; en))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I need a bit information regarding execve(2) sys call failure on no memory.

when execve(2) exits with ENOMEM, it will fail to return back to the calling 
program as it receives the SIGKILL from the kernel.

Is it a right behavior that execve() will not return to calling 
program on ENOMEM. As I understood execve(2) will not return only on success.

As errno will be lost, its very diffcult to judge execve(2) status.

If not expected behaviour,  I can provide a testcase for this.

Please let me about this.

Thanks,
Halesh

