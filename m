Return-Path: <linux-kernel-owner+w=401wt.eu-S1751141AbXCPCKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbXCPCKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 22:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXCPCKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 22:10:19 -0400
Received: from main.gmane.org ([80.91.229.2]:42318 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbXCPCKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 22:10:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: AMD64 kernel oops
Date: Fri, 16 Mar 2007 02:06:35 +0000 (UTC)
Message-ID: <loom.20070316T030249-726@post.gmane.org>
References: <200703151623.19439.lists@naasa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.60.176.179 (Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en) AppleWebKit/419 (KHTML, like Gecko) Safari/419.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Platte <lists <at> naasa.net> writes:

> Pid: 14, comm: events/0 Not tainted 2.6.18-4-amd64 #1
> RIP: 0010:[<ffffffff802ec036>]  [<ffffffff802ec036>] keyring_destroy+0x32/0x96

[Snip]

> Can this oops be caused by a known and already 
> fixed problem in a newer kernel versions? In this case I would submit a bug 
> to the Debian BTS. Otherwise what can I do to further reproduce and debug 
> this oops?
> 

Check out http://bugzilla.kernel.org/show_bug.cgi?id=8067 which is a duplicate of
http://bugzilla.kernel.org/show_bug.cgi?id=7727 which is fixed. There is a patch available on the 
bugzilla if you want to try it out. 

HTH
Parag



